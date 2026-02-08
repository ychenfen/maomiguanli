@echo off
chcp 65001 >nul 2>&1
title 校园流浪猫救助平台 - 一键启动
color 0A

echo.
echo  ========================================================
echo     校园流浪猫救助平台 - Windows 一键启动
echo  ========================================================
echo.

REM ==================== 配置区（按需修改） ====================
set MYSQL_HOST=127.0.0.1
set MYSQL_PORT=3306
set MYSQL_DB=cat_rescue
set MYSQL_USER=root
set MYSQL_PASS=123456
set BACKEND_PORT=8080
set USER_PORT=5000
set ADMIN_PORT=5001
REM ==========================================================

REM 切换到脚本所在目录
cd /d "%~dp0"

REM ========== [1/7] 停止旧服务 ==========
echo  [1/7] 停止旧服务...
for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":%BACKEND_PORT% " ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":%USER_PORT% " ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":%ADMIN_PORT% " ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a >nul 2>&1
)
timeout /t 1 /nobreak >nul
echo        [OK] 旧服务已清理
echo.

REM ========== [2/7] 检查 Java ==========
echo  [2/7] 检查 Java 环境...
java -version >nul 2>&1
if errorlevel 1 (
    echo.
    echo  [ERROR] 未检测到 Java！
    echo          请安装 JDK 17+: https://adoptium.net/
    echo          安装后请确保 java 命令在 PATH 中可用
    echo.
    pause
    exit /b 1
)
for /f "tokens=3" %%v in ('java -version 2^>^&1 ^| findstr /i "version"') do (
    echo        [OK] Java %%v
)
echo.

REM ========== [3/7] 检查 Node.js ==========
echo  [3/7] 检查 Node.js 环境...
node -v >nul 2>&1
if errorlevel 1 (
    echo.
    echo  [ERROR] 未检测到 Node.js！
    echo          请安装 Node.js 18+: https://nodejs.org/
    echo.
    pause
    exit /b 1
)
for /f %%v in ('node -v') do echo        [OK] Node.js %%v
echo.

REM ========== [4/7] 检查 MySQL 并初始化数据库 ==========
echo  [4/7] 检查数据库...
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h%MYSQL_HOST% -P%MYSQL_PORT% -e "SELECT 1" >nul 2>&1
if errorlevel 1 (
    echo.
    echo  [WARN] MySQL 连接失败！
    echo         请确保 MySQL 服务已启动，且账号密码正确
    echo         当前配置: %MYSQL_USER%@%MYSQL_HOST%:%MYSQL_PORT% 密码=%MYSQL_PASS%
    echo.
    echo         如需修改密码，请编辑 start.bat 第 16 行 MYSQL_PASS
    echo.
    set /p SKIP_DB="  是否跳过数据库检查继续启动？(Y/N): "
    if /i not "%SKIP_DB%"=="Y" (
        pause
        exit /b 1
    )
    goto START_BACKEND
)
echo        [OK] MySQL 连接成功

REM 检查数据库是否存在
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h%MYSQL_HOST% -P%MYSQL_PORT% -e "USE %MYSQL_DB%" >nul 2>&1
if errorlevel 1 (
    echo        [INFO] 数据库 %MYSQL_DB% 不存在，正在自动初始化...
    mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h%MYSQL_HOST% -P%MYSQL_PORT% < cat_rescue.sql
    if errorlevel 1 (
        echo  [ERROR] 数据库初始化失败！请检查 cat_rescue.sql 文件
        pause
        exit /b 1
    )
    echo        [OK] 数据库初始化完成（含测试数据）
) else (
    echo        [OK] 数据库 %MYSQL_DB% 已就绪
)
echo.

:START_BACKEND
REM ========== [5/7] 启动后端 ==========
echo  [5/7] 启动后端服务（端口 %BACKEND_PORT%）...

REM 安装前端依赖（如果需要）
if not exist "frontend\node_modules" (
    echo        [INFO] 首次运行，安装用户端依赖...
    cd frontend
    call npm install --production >nul 2>&1
    cd ..
)
if not exist "admin-frontend\node_modules" (
    echo        [INFO] 首次运行，安装管理端依赖...
    cd admin-frontend
    call npm install --production >nul 2>&1
    cd ..
)

REM 确保 uploads 目录存在
if not exist "uploads" mkdir uploads

cd backend
start "后端-SpringBoot" /min cmd /c "java -jar cat-rescue.jar --spring.profiles.active=local --server.port=%BACKEND_PORT% --spring.datasource.url=jdbc:mysql://%MYSQL_HOST%:%MYSQL_PORT%/%MYSQL_DB%?useUnicode=true^&characterEncoding=utf-8^&serverTimezone=Asia/Shanghai --spring.datasource.username=%MYSQL_USER% --spring.datasource.password=%MYSQL_PASS% > backend.log 2>&1"
cd ..

REM 等待后端启动
set /a WAIT=0
:WAIT_BACKEND
timeout /t 2 /nobreak >nul
set /a WAIT+=1
curl -s -o nul -w "" http://localhost:%BACKEND_PORT%/api/cats/page?page=1^&size=1 >nul 2>&1
if errorlevel 1 (
    if %WAIT% lss 20 (
        echo        等待后端启动... (%WAIT%/20)
        goto WAIT_BACKEND
    ) else (
        echo  [WARN] 后端启动超时，请检查 backend\backend.log
        echo         将继续启动前端...
    )
) else (
    echo        [OK] 后端服务已就绪
)
echo.

REM ========== [6/7] 启动前端 ==========
echo  [6/7] 启动用户端前端（端口 %USER_PORT%）...
cd frontend
start "用户端-NodeJS" /min cmd /c "set PORT=%USER_PORT% && set API_PORT=%BACKEND_PORT% && node server.js > frontend.log 2>&1"
cd ..
timeout /t 2 /nobreak >nul
echo        [OK] 用户端启动中
echo.

REM ========== [7/7] 启动管理端 ==========
echo  [7/7] 启动管理端前端（端口 %ADMIN_PORT%）...
cd admin-frontend
start "管理端-NodeJS" /min cmd /c "set PORT=%ADMIN_PORT% && set API_PORT=%BACKEND_PORT% && node server.js > admin.log 2>&1"
cd ..
timeout /t 2 /nobreak >nul
echo        [OK] 管理端启动中
echo.

REM ========== 启动完成 ==========
echo.
echo  ========================================================
echo     启动完成！
echo  ========================================================
echo.
echo     用户端首页:    http://localhost:%USER_PORT%
echo     云养/捐献/打赏: http://localhost:%USER_PORT%/mvp/mvp-login.html
echo     管理后台:      http://localhost:%ADMIN_PORT%/login.html
echo     后端 API:      http://localhost:%BACKEND_PORT%/api
echo.
echo  --------------------------------------------------------
echo     测试账号:
echo       管理员:  admin / 123456
echo       用户:    zhangsan / 123456
echo  --------------------------------------------------------
echo.
echo     停止服务:  运行 stop.bat
echo     查看日志:  backend\backend.log / frontend\frontend.log
echo.
echo  ========================================================
echo.

REM 打开浏览器
echo  正在打开浏览器...
start "" "http://localhost:%USER_PORT%/mvp/mvp-login.html"
timeout /t 1 /nobreak >nul
start "" "http://localhost:%ADMIN_PORT%/login.html"

echo.
echo  按任意键关闭此窗口（服务将继续在后台运行）...
pause >nul
