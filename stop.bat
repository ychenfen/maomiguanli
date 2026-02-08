@echo off
chcp 65001 >nul 2>&1
title 猫咪救助系统 - 停止服务
color 0C

echo ============================================
echo    猫咪救助系统 - 停止所有服务
echo ============================================
echo.

REM 停止 Node.js 前端服务
echo [1/2] 停止前端服务...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":5000 " ^| findstr "LISTENING"') do (
    echo     停止用户端 PID=%%a
    taskkill /F /PID %%a >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":5001 " ^| findstr "LISTENING"') do (
    echo     停止管理端 PID=%%a
    taskkill /F /PID %%a >nul 2>&1
)
echo [OK] 前端服务已停止

REM 停止 Java 后端服务
echo [2/2] 停止后端服务...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8080 " ^| findstr "LISTENING"') do (
    echo     停止后端 PID=%%a
    taskkill /F /PID %%a >nul 2>&1
)
echo [OK] 后端服务已停止

echo.
echo ============================================
echo    所有服务已停止
echo ============================================
echo.
pause
