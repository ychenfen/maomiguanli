@echo off
chcp 65001 >nul
title 动物救助系统 - 查看状态
color 0B

:refresh
cls
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║                                                            ║
echo ║           🐾 动物救助系统 - 服务状态监控 🐾              ║
echo ║                                                            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo 刷新时间: %date% %time%
echo.

:: ========== 后端服务状态 ==========
echo ┌────────────────────────────────────────────────────────────┐
echo │  后端服务 (端口: 8080)                                     │
echo ├────────────────────────────────────────────────────────────┤
netstat -ano | findstr ":8080" | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo │  状态: ✗ 未运行                                           │
    echo │  访问: http://localhost:8080/api                          │
) else (
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080" ^| findstr "LISTENING"') do (
        echo │  状态: ✓ 运行中                                           │
        echo │  PID:   %%a                                               │
        echo │  访问: http://localhost:8080/api                          │
        echo │  文档: http://localhost:8080/swagger-ui.html              │
    )
)
echo └────────────────────────────────────────────────────────────┘
echo.

:: ========== 用户前端状态 ==========
echo ┌────────────────────────────────────────────────────────────┐
echo │  用户前端 (端口: 5000)                                     │
echo ├────────────────────────────────────────────────────────────┤
netstat -ano | findstr ":5000" | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo │  状态: ✗ 未运行                                           │
    echo │  访问: http://localhost:5000                              │
) else (
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5000" ^| findstr "LISTENING"') do (
        echo │  状态: ✓ 运行中                                           │
        echo │  PID:   %%a                                               │
        echo │  访问: http://localhost:5000                              │
    )
)
echo └────────────────────────────────────────────────────────────┘
echo.

:: ========== 管理后台状态 ==========
echo ┌────────────────────────────────────────────────────────────┐
echo │  管理后台 (端口: 5001)                                     │
echo ├────────────────────────────────────────────────────────────┤
netstat -ano | findstr ":5001" | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo │  状态: ✗ 未运行                                           │
    echo │  访问: http://localhost:5001                              │
) else (
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5001" ^| findstr "LISTENING"') do (
        echo │  状态: ✓ 运行中                                           │
        echo │  PID:   %%a                                               │
        echo │  访问: http://localhost:5001/login.html                   │
    )
)
echo └────────────────────────────────────────────────────────────┘
echo.

:: ========== 数据库状态 ==========
echo ┌────────────────────────────────────────────────────────────┐
echo │  MySQL数据库 (端口: 3306)                                  │
echo ├────────────────────────────────────────────────────────────┤
netstat -ano | findstr ":3306" | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo │  状态: ✗ 未运行                                           │
) else (
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":3306" ^| findstr "LISTENING"') do (
        echo │  状态: ✓ 运行中                                           │
        echo │  PID:   %%a                                               │
    )
)
echo └────────────────────────────────────────────────────────────┘
echo.

:: ========== 系统资源 ==========
echo ┌────────────────────────────────────────────────────────────┐
echo │  系统资源                                                  │
echo ├────────────────────────────────────────────────────────────┤

:: 获取Java进程数
set java_count=0
for /f %%a in ('tasklist ^| findstr /i "java.exe" ^| find /c /v ""') do set java_count=%%a
echo │  Java进程数: %java_count%                                     │

:: 获取Node进程数
set node_count=0
for /f %%a in ('tasklist ^| findstr /i "node.exe" ^| find /c /v ""') do set node_count=%%a
echo │  Node进程数: %node_count%                                     │

echo └────────────────────────────────────────────────────────────┘
echo.

:: ========== 日志文件 ==========
echo ┌────────────────────────────────────────────────────────────┐
echo │  日志文件                                                  │
echo ├────────────────────────────────────────────────────────────┤

if exist "backend\backend.log" (
    for %%a in ("backend\backend.log") do (
        echo │  后端日志: backend\backend.log (%%~za 字节^)
    )
) else (
    echo │  后端日志: 不存在                                         │
)

if exist "frontend\frontend.log" (
    for %%a in ("frontend\frontend.log") do (
        echo │  前端日志: frontend\frontend.log (%%~za 字节^)
    )
) else (
    echo │  前端日志: 不存在                                         │
)

if exist "admin-frontend\admin.log" (
    for %%a in ("admin-frontend\admin.log") do (
        echo │  管理后台日志: admin-frontend\admin.log (%%~za 字节^)
    )
) else (
    echo │  管理后台日志: 不存在                                     │
)

echo └────────────────────────────────────────────────────────────┘
echo.

:: ========== 快捷操作 ==========
echo ┌────────────────────────────────────────────────────────────┐
echo │  快捷操作                                                  │
echo ├────────────────────────────────────────────────────────────┤
echo │  [1] 打开用户前端                                          │
echo │  [2] 打开管理后台                                          │
echo │  [3] 打开API文档                                           │
echo │  [4] 查看后端日志                                          │
echo │  [5] 查看前端日志                                          │
echo │  [6] 查看管理后台日志                                      │
echo │  [R] 刷新状态                                              │
echo │  [S] 停止所有服务                                          │
echo │  [Q] 退出                                                  │
echo └────────────────────────────────────────────────────────────┘
echo.

choice /c 123456RSQ /n /m "请选择操作: "

if errorlevel 9 goto end
if errorlevel 8 goto stop_services
if errorlevel 7 goto refresh
if errorlevel 6 goto view_admin_log
if errorlevel 5 goto view_frontend_log
if errorlevel 4 goto view_backend_log
if errorlevel 3 goto open_api_doc
if errorlevel 2 goto open_admin
if errorlevel 1 goto open_frontend

:open_frontend
start http://localhost:5000
goto refresh

:open_admin
start http://localhost:5001/login.html
goto refresh

:open_api_doc
start http://localhost:8080/swagger-ui.html
goto refresh

:view_backend_log
if exist "backend\backend.log" (
    start notepad "backend\backend.log"
) else (
    echo 日志文件不存在！
    timeout /t 2 /nobreak >nul
)
goto refresh

:view_frontend_log
if exist "frontend\frontend.log" (
    start notepad "frontend\frontend.log"
) else (
    echo 日志文件不存在！
    timeout /t 2 /nobreak >nul
)
goto refresh

:view_admin_log
if exist "admin-frontend\admin.log" (
    start notepad "admin-frontend\admin.log"
) else (
    echo 日志文件不存在！
    timeout /t 2 /nobreak >nul
)
goto refresh

:stop_services
echo.
echo 正在停止所有服务...
call 停止服务.bat
echo.
echo 所有服务已停止！
timeout /t 2 /nobreak >nul
goto refresh

:end
exit
