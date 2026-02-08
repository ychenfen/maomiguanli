#requires -version 5.1
Set-StrictMode -Version Latest

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

if (-not $env:APP_PORT) { $env:APP_PORT = "8080" }
if (-not $env:API_HOST) { $env:API_HOST = "127.0.0.1" }
if (-not $env:API_PORT) { $env:API_PORT = $env:APP_PORT }

if (-not $env:DB_HOST) { $env:DB_HOST = "127.0.0.1" }
if (-not $env:DB_PORT) { $env:DB_PORT = "3306" }
if (-not $env:DB_NAME) { $env:DB_NAME = "cat_rescue" }
if (-not $env:DB_USER) { $env:DB_USER = "root" }
if (-not $env:DB_PASS) { $env:DB_PASS = "123456" }

if (-not $env:CORS_ALLOWED_ORIGINS) {
  $env:CORS_ALLOWED_ORIGINS = "http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:5000,http://localhost:5001"
}
if (-not $env:SPRING_PROFILES_ACTIVE) { $env:SPRING_PROFILES_ACTIVE = "local" }

function Write-Log($msg) {
  $ts = (Get-Date).ToString("HH:mm:ss")
  Write-Host "[$ts] $msg"
}

Write-Log "检查 Java..."
try {
  & java -version 2>$null | Out-Null
} catch {
  Write-Error "未检测到 Java，请先安装 Java 17+"
  exit 1
}
& java -version 2>&1 | Select-Object -First 1 | ForEach-Object { Write-Host $_ }

Write-Log "检查 Node.js..."
try {
  & node -v 2>$null | Out-Null
} catch {
  Write-Error "未检测到 Node.js，请先安装 Node 16+"
  exit 1
}
& node -v 2>&1 | Select-Object -First 1 | ForEach-Object { Write-Host $_ }

Write-Log "检查 MySQL 连接..."
$mysqlOk = $false
if (Get-Command mysqladmin -ErrorAction SilentlyContinue) {
  try {
    if ($env:DB_PASS) {
      & mysqladmin ping -h $env:DB_HOST -P $env:DB_PORT -u $env:DB_USER -p$env:DB_PASS | Out-Null
    } else {
      & mysqladmin ping -h $env:DB_HOST -P $env:DB_PORT -u $env:DB_USER | Out-Null
    }
    $mysqlOk = $true
  } catch {
    $mysqlOk = $false
  }
} else {
  try {
    $tcp = Test-NetConnection -ComputerName $env:DB_HOST -Port $env:DB_PORT -WarningAction SilentlyContinue
    $mysqlOk = $tcp.TcpTestSucceeded
  } catch {
    $mysqlOk = $false
  }
}

if (-not $mysqlOk) {
  Write-Log "MySQL 未就绪：请确认 MySQL 已启动，并执行 init-db.bat 初始化数据库。"
} else {
  Write-Log "MySQL 端口可达。"
}

if (Get-Command mysql -ErrorAction SilentlyContinue) {
  try {
    $dbExists = $null
    if ($env:DB_PASS) {
      $dbExists = & mysql -h $env:DB_HOST -P $env:DB_PORT -u $env:DB_USER -p$env:DB_PASS -N -s -e "SHOW DATABASES LIKE '$($env:DB_NAME)';" 2>$null
    } else {
      $dbExists = & mysql -h $env:DB_HOST -P $env:DB_PORT -u $env:DB_USER -N -s -e "SHOW DATABASES LIKE '$($env:DB_NAME)';" 2>$null
    }
    if (-not $dbExists) {
      Write-Log "数据库 $($env:DB_NAME) 不存在：请先运行初始化脚本。"
    }
  } catch {
    # ignore
  }
}

Write-Log "启动后端 (端口 $($env:APP_PORT))..."
$backendLog = Join-Path $Root "backend\backend.log"
Start-Process -FilePath "java" -ArgumentList @("-jar","cat-rescue.jar","--spring.profiles.active=$($env:SPRING_PROFILES_ACTIVE)") -WorkingDirectory (Join-Path $Root "backend") -RedirectStandardOutput $backendLog -RedirectStandardError $backendLog -NoNewWindow | Out-Null
Write-Log "后端日志: $backendLog"

Write-Log "启动用户前端 (端口 5000)..."
$frontendLog = Join-Path $Root "frontend\frontend.log"
Start-Process -FilePath "node" -ArgumentList @("server.js") -WorkingDirectory (Join-Path $Root "frontend") -RedirectStandardOutput $frontendLog -RedirectStandardError $frontendLog -NoNewWindow | Out-Null
Write-Log "用户前端日志: $frontendLog"

Write-Log "启动管理后台 (端口 5001)..."
$adminLog = Join-Path $Root "admin-frontend\admin.log"
Start-Process -FilePath "node" -ArgumentList @("server.js") -WorkingDirectory (Join-Path $Root "admin-frontend") -RedirectStandardOutput $adminLog -RedirectStandardError $adminLog -NoNewWindow | Out-Null
Write-Log "管理后台日志: $adminLog"

Start-Sleep -Seconds 6

function Get-HttpStatus($url) {
  try {
    $resp = Invoke-WebRequest -UseBasicParsing -Uri $url -Method Get -TimeoutSec 5
    return $resp.StatusCode
  } catch {
    if ($_.Exception.Response) {
      return $_.Exception.Response.StatusCode.value__
    }
    return 0
  }
}

Write-Log "健康检查..."
$healthUrl = "http://127.0.0.1:$($env:APP_PORT)/actuator/health"
$healthStatus = Get-HttpStatus $healthUrl
if ($healthStatus -ne 200) {
  $altUrl = "http://127.0.0.1:$($env:APP_PORT)/api/health"
  $altStatus = Get-HttpStatus $altUrl
}
$frontendStatus = Get-HttpStatus "http://127.0.0.1:5000/"
$adminStatus = Get-HttpStatus "http://127.0.0.1:5001/"

Write-Log "后端健康检查: $healthUrl -> $healthStatus"
if ($altUrl) { Write-Log "后端备用检查: $altUrl -> $altStatus" }
Write-Log "用户前端: http://127.0.0.1:5000/ -> $frontendStatus"
Write-Log "管理后台: http://127.0.0.1:5001/ -> $adminStatus"
Write-Log "启动完成。"
