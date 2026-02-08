@echo off
chcp 65001 >nul
title 后端服务

echo ========================================
echo     猫咪救助系统 - 后端服务
echo ========================================
echo.

cd /d "%~dp0"

echo 正在启动后端服务...
echo 端口: 8080
echo.
echo 请等待启动完成（约20-30秒）
echo 看到 "Started CatRescueApplication" 表示启动成功
echo.

java -jar cat-rescue.jar --spring.profiles.active=prod

pause
