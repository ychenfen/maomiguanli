@echo off
chcp 65001 >nul 2>&1
title 校园流浪猫救助平台 - 停止服务
color 0C

echo.
echo  ========================================================
echo     校园流浪猫救助平台 - 停止所有服务
echo  ========================================================
echo.

set STOPPED=0

REM 停止用户端前端（端口 5000）
echo  [1/3] 停止用户端前端（端口 5000）...
for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":5000 " ^| findstr "LISTENING"') do (
    echo        停止进程 PID=%%a
    taskkill /F /PID %%a >nul 2>&1
    set STOPPED=1
)
if %STOPPED%==0 (
    echo        [--] 未运行
) else (
    echo        [OK] 已停止
)
set STOPPED=0
echo.

REM 停止管理端前端（端口 5001）
echo  [2/3] 停止管理端前端（端口 5001）...
for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":5001 " ^| findstr "LISTENING"') do (
    echo        停止进程 PID=%%a
    taskkill /F /PID %%a >nul 2>&1
    set STOPPED=1
)
if %STOPPED%==0 (
    echo        [--] 未运行
) else (
    echo        [OK] 已停止
)
set STOPPED=0
echo.

REM 停止后端服务（端口 8080）
echo  [3/3] 停止后端服务（端口 8080）...
for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":8080 " ^| findstr "LISTENING"') do (
    echo        停止进程 PID=%%a
    taskkill /F /PID %%a >nul 2>&1
    set STOPPED=1
)
if %STOPPED%==0 (
    echo        [--] 未运行
) else (
    echo        [OK] 已停止
)
echo.

echo  ========================================================
echo     所有服务已停止
echo  ========================================================
echo.
echo  如需重新启动，请运行 start.bat
echo.
pause
