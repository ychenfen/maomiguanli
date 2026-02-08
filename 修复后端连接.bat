@echo off
chcp 65001 >nul
title 修复后端数据库连接

echo ========================================
echo     修复后端数据库连接
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] 停止后端服务...
taskkill /F /FI "WINDOWTITLE eq 后端服务*" 2>nul
timeout /t 3 >nul

echo [2/4] 检查配置文件...
if not exist "backend\application-prod.yml" (
    echo 错误：配置文件不存在！
    pause
    exit /b 1
)

echo [3/4] 验证数据库配置...
findstr /C:"password: 123456" backend\application-prod.yml >nul
if errorlevel 1 (
    echo 警告：数据库密码可能未配置！
)

echo [4/4] 重新启动后端...
echo.
echo 正在启动后端服务，请等待...
echo 看到 "Started CatRescueApplication" 表示成功
echo.

cd backend
start "后端服务" cmd /k "java -jar cat-rescue.jar --spring.profiles.active=prod"

echo.
echo 后端服务已启动，请查看新窗口的启动日志
echo 如果看到数据库连接错误，请检查：
echo   1. MySQL服务是否运行
echo   2. 数据库密码是否为 123456
echo   3. 数据库 cat_rescue 是否存在
echo.
pause
