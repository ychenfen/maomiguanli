@echo off
chcp 65001 >nul
title 猫咪领养系统 - 停止服务

echo ========================================
echo     校园流浪猫救助平台 - 停止服务
echo ========================================
echo.

echo 正在停止服务...
echo.

:: 停止占用8080端口的进程（后端）
set backend_stopped=0
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080" ^| findstr "LISTENING"') do (
    echo  - 停止后端服务 (PID: %%a)
    taskkill /F /PID %%a >nul 2>&1
    set backend_stopped=1
)

if %backend_stopped%==0 (
    echo  - 后端服务未运行
)

:: 停止占用5000端口的进程（前端）
set frontend_stopped=0
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5000" ^| findstr "LISTENING"') do (
    echo  - 停止前端服务 (PID: %%a)
    taskkill /F /PID %%a >nul 2>&1
    set frontend_stopped=1
)

if %frontend_stopped%==0 (
    echo  - 前端服务未运行
)

:: 停止占用5001端口的进程（管理后台）
set admin_stopped=0
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5001" ^| findstr "LISTENING"') do (
    echo  - 停止管理后台服务 (PID: %%a)
    taskkill /F /PID %%a >nul 2>&1
    set admin_stopped=1
)

if %admin_stopped%==0 (
    echo  - 管理后台服务未运行
)

echo.
echo ========================================
echo     所有服务已停止
echo ========================================
echo.
pause
