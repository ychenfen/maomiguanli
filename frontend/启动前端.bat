@echo off
chcp 65001 >nul
title 用户前端服务

echo ========================================
echo     猫咪救助系统 - 用户前端
echo ========================================
echo.

cd /d "%~dp0"

echo 正在启动用户前端服务...
echo 端口: 5000
echo 访问地址: http://localhost:5000
echo.

node server.js

pause
