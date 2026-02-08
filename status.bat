@echo off
chcp 65001 >nul 2>&1
title 校园流浪猫救助平台 - 服务状态
color 0E

echo.
echo  ========================================================
echo     校园流浪猫救助平台 - 服务状态检查
echo  ========================================================
echo.

REM 检查后端
echo  [后端服务] 端口 8080
netstat -aon 2>nul | findstr ":8080 " | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo        状态: 未运行
) else (
    for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":8080 " ^| findstr "LISTENING"') do (
        echo        状态: 运行中 (PID=%%a)
    )
    curl -s -o nul -w "        响应: HTTP %%{http_code}\n" http://localhost:8080/api/cats/page?page=1^&size=1 2>nul
)
echo.

REM 检查用户端
echo  [用户端前端] 端口 5000
netstat -aon 2>nul | findstr ":5000 " | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo        状态: 未运行
) else (
    for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":5000 " ^| findstr "LISTENING"') do (
        echo        状态: 运行中 (PID=%%a)
    )
)
echo.

REM 检查管理端
echo  [管理端前端] 端口 5001
netstat -aon 2>nul | findstr ":5001 " | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo        状态: 未运行
) else (
    for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":5001 " ^| findstr "LISTENING"') do (
        echo        状态: 运行中 (PID=%%a)
    )
)
echo.

REM 检查 MySQL
echo  [MySQL 数据库] 端口 3306
netstat -aon 2>nul | findstr ":3306 " | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo        状态: 未运行
) else (
    echo        状态: 运行中
)
echo.

echo  ========================================================
echo.
echo  访问地址:
echo    用户端:      http://localhost:5000
echo    云养/捐献:   http://localhost:5000/mvp/mvp-login.html
echo    管理后台:    http://localhost:5001/login.html
echo.
echo  ========================================================
echo.
pause
