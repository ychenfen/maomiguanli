@echo off
chcp 65001 >nul 2>&1
title 猫咪救助系统 - 一键启动
color 0A

echo ============================================
echo    猫咪救助系统 - 一键启动
echo ============================================
echo.

REM ========== 配置区 ==========
set MYSQL_HOST=127.0.0.1
set MYSQL_PORT=3306
set MYSQL_DB=cat_rescue
set MYSQL_USER=root
set MYSQL_PASS=123456
set BACKEND_PORT=8080
set USER_PORT=5000
set ADMIN_PORT=5001
set CORS_ALLOWED_ORIGINS=http://localhost:5000,http://localhost:5001,http://localhost:5173,http://localhost:3000,*

REM ========== 检查 Java ==========
echo [1/5] 检查 Java 环境...
java -version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 未检测到 Java，请安装 JDK 17+ 并配置 PATH
    echo 下载地址: https://adoptium.net/
    pause
    exit /b 1
)
echo [OK] Java 已安装

REM ========== 检查 Node.js ==========
echo [2/5] 检查 Node.js 环境...
node -v >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 未检测到 Node.js，请安装 Node.js 18+ 并配置 PATH
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)
echo [OK] Node.js 已安装

REM ========== 检查 MySQL ==========
echo [3/5] 检查 MySQL 连接...
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h%MYSQL_HOST% -P%MYSQL_PORT% -e "SELECT 1" >nul 2>&1
if errorlevel 1 (
    echo [WARN] MySQL 连接失败，请确保 MySQL 已启动
    echo       连接信息: %MYSQL_USER%@%MYSQL_HOST%:%MYSQL_PORT%
    echo       如需初始化数据库，请先执行: mysql -u%MYSQL_USER% -p%MYSQL_PASS% ^< cat_rescue.sql
    echo.
    echo 是否继续启动？(Y/N)
    set /p CONTINUE=
    if /i not "%CONTINUE%"=="Y" exit /b 1
)

REM ========== 初始化数据库（如果不存在）==========
echo [3/5] 检查数据库...
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h%MYSQL_HOST% -P%MYSQL_PORT% -e "USE %MYSQL_DB%" >nul 2>&1
if errorlevel 1 (
    echo [INFO] 数据库 %MYSQL_DB% 不存在，正在初始化...
    mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h%MYSQL_HOST% -P%MYSQL_PORT% < cat_rescue.sql
    if errorlevel 1 (
        echo [ERROR] 数据库初始化失败
        pause
        exit /b 1
    )
    echo [OK] 数据库初始化完成
) else (
    echo [OK] 数据库 %MYSQL_DB% 已存在
)

REM ========== 创建 uploads 目录 ==========
if not exist "uploads" mkdir uploads

REM ========== 启动后端 ==========
echo [4/5] 启动后端服务 (端口 %BACKEND_PORT%)...
cd backend
start "猫咪救助-后端" /min cmd /c "set CORS_ALLOWED_ORIGINS=%CORS_ALLOWED_ORIGINS% && java -jar cat-rescue.jar --spring.profiles.active=local --server.port=%BACKEND_PORT% --spring.datasource.url=jdbc:mysql://%MYSQL_HOST%:%MYSQL_PORT%/%MYSQL_DB%?useUnicode=true^&characterEncoding=utf-8^&serverTimezone=Asia/Shanghai --spring.datasource.username=%MYSQL_USER% --spring.datasource.password=%MYSQL_PASS% 2>&1"
cd ..

REM 等待后端启动
echo     等待后端启动...
set /a WAIT_COUNT=0
:WAIT_BACKEND
timeout /t 2 /nobreak >nul
set /a WAIT_COUNT+=1
curl -s http://localhost:%BACKEND_PORT%/api/cats/page?page=1^&size=1 >nul 2>&1
if errorlevel 1 (
    if %WAIT_COUNT% lss 15 (
        echo     等待中... (%WAIT_COUNT%/15)
        goto WAIT_BACKEND
    ) else (
        echo [WARN] 后端启动超时，但将继续启动前端
    )
) else (
    echo [OK] 后端服务已启动
)

REM ========== 启动前端 ==========
echo [5/5] 启动前端服务...

cd frontend
start "猫咪救助-用户端" /min cmd /c "set USER_PORT=%USER_PORT% && set API_PORT=%BACKEND_PORT% && node server.js 2>&1"
cd ..

cd admin-frontend
start "猫咪救助-管理端" /min cmd /c "set ADMIN_PORT=%ADMIN_PORT% && set API_PORT=%BACKEND_PORT% && node server.js 2>&1"
cd ..

timeout /t 3 /nobreak >nul

echo.
echo ============================================
echo    所有服务已启动！
echo ============================================
echo.
echo    后端 API:    http://localhost:%BACKEND_PORT%
echo    用户端:      http://localhost:%USER_PORT%
echo    管理后台:    http://localhost:%ADMIN_PORT%
echo.
echo    管理员账号:  admin / 123456
echo    测试用户:    user1 / 123456
echo.
echo    关闭方式:    运行 stop.bat 或关闭所有命令行窗口
echo ============================================
echo.

REM 打开浏览器
start "" "http://localhost:%ADMIN_PORT%/login.html"
start "" "http://localhost:%USER_PORT%"

echo 按任意键关闭此窗口（服务将继续在后台运行）...
pause >nul
