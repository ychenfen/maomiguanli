@echo off
chcp 65001 >nul
title 猫咪领养系统 - 一键启动

echo ========================================
echo     校园流浪猫救助平台 - 一键启动
echo ========================================
echo.

:: 停止之前的服务
echo [1/5] 停止之前的服务...
echo.

:: 停止占用8080端口的进程
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080" ^| findstr "LISTENING"') do (
    echo   - 停止后端服务 (PID: %%a)
    taskkill /F /PID %%a >nul 2>&1
)

:: 停止占用5000端口的进程
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5000" ^| findstr "LISTENING"') do (
    echo   - 停止前端服务 (PID: %%a)
    taskkill /F /PID %%a >nul 2>&1
)

timeout /t 2 /nobreak >nul
echo   ✓ 旧服务已停止
echo.

:: 检查环境
echo [2/5] 检查运行环境...
echo.

:: 检查Java
java -version >nul 2>&1
if errorlevel 1 (
    echo   ✗ 未检测到 Java 环境
    echo   请安装 JDK 17+: https://adoptium.net/
    pause
    exit /b 1
)
echo   ✓ Java 环境正常

:: 检查Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo   ✗ 未检测到 Node.js 环境
    echo   请安装 Node.js: https://nodejs.org/
    pause
    exit /b 1
)
echo   ✓ Node.js 环境正常

:: 检查MySQL
mysql --version >nul 2>&1
if errorlevel 1 (
    echo   ⚠ 未检测到 MySQL 客户端
    echo   请确保 MySQL 已安装并运行
) else (
    echo   ✓ MySQL 环境正常
)
echo.

:: 启动后端
echo [3/5] 启动后端服务...
echo.
cd /d "%~dp0backend"
start /b java -jar cat-rescue.jar --spring.profiles.active=prod >backend.log 2>&1
echo   ✓ 后端服务启动中 (端口: 8080)
echo.

:: 等待后端启动
echo [4/5] 等待后端就绪...
echo.
set /a count=0
:wait_backend
timeout /t 2 /nobreak >nul
set /a count+=1

:: 检查后端是否启动
netstat -ano | findstr ":8080" | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    if %count% lss 15 (
        echo   - 等待中... (%count%/15^)
        goto wait_backend
    ) else (
        echo   ✗ 后端启动超时
        echo   请检查 backend\backend.log 查看错误信息
        pause
        exit /b 1
    )
)
echo   ✓ 后端服务已就绪
echo.

:: 启动前端
echo [5/5] 启动前端服务...
echo.
cd /d "%~dp0frontend"
start /b node server.js >frontend.log 2>&1
timeout /t 2 /nobreak >nul
echo   ✓ 前端服务启动中 (端口: 5000)
echo.

:: 验证前端启动
netstat -ano | findstr ":5000" | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo   ✗ 前端启动失败
    echo   请检查 frontend\frontend.log 查看错误信息
    pause
    exit /b 1
)

:: 启动成功
echo.
echo ========================================
echo     系统启动成功！
echo ========================================
echo.
echo  访问地址:
echo  ├─ 前端页面: http://localhost:5000
echo  ├─ 后端API:  http://localhost:8080/api
echo  └─ API文档:  http://localhost:8080/doc.html
echo.
echo  默认账号:
echo  ├─ 管理员: admin / 123456
echo  └─ 用户:   zhangsan / 123456
echo.
echo  服务状态:
echo  ├─ 后端: 运行中 (端口 8080)
echo  └─ 前端: 运行中 (端口 5000)
echo.
echo  日志文件:
echo  ├─ 后端: backend\backend.log
echo  └─ 前端: frontend\frontend.log
echo.
echo ========================================
echo.
echo  按任意键打开浏览器...
pause >nul

:: 打开浏览器
start http://localhost:5000

echo.
echo  浏览器已打开
echo  关闭此窗口不会停止服务
echo  如需停止服务，请运行: 停止服务.bat
echo.
pause
