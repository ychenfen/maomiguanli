@echo off
chcp 65001 >nul
title 管理后台服务

echo ========================================
echo     猫咪救助系统 - 管理后台
echo ========================================
echo.

cd /d "%~dp0"

echo 正在启动管理后台服务...
echo 端口: 5001
echo 访问地址: http://localhost:5001
echo.

node server.js

pause
