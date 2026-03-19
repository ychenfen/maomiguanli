@echo off
chcp 65001 >nul
title 动物救助系统 - 完整启动
color 0A

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║                                                            ║
echo ║           🐾 动物救助系统 - 完整启动脚本 🐾              ║
echo ║                                                            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

:: ========== 环境检查 ==========
echo [检查] 正在检查运行环境...
echo.

:: 检查Java
echo [1/3] 检查Java环境...
java -version >nul 2>&1
if errorlevel 1 (
    color 0C
    echo [错误] 未检测到Java环境！
    echo        请先安装Java 17或更高版本
    echo        下载地址: https://www.oracle.com/java/technologies/downloads/
    echo.
    pause
    exit /b 1
) else (
    echo [成功] Java环境检测通过
)

:: 检查Node.js
echo [2/3] 检查Node.js环境...
node -v >nul 2>&1
if errorlevel 1 (
    color 0C
    echo [错误] 未检测到Node.js环境！
    echo        请先安装Node.js 16或更高版本
    echo        下载地址: https://nodejs.org/
    echo.
    pause
    exit /b 1
) else (
    echo [成功] Node.js环境检测通过
)

:: 检查必要文件
echo [3/3] 检查必要文件...
if not exist "backend\cat-rescue.jar" (
    color 0C
    echo [错误] 未找到后端jar文件: backend\cat-rescue.jar
    echo.
    pause
    exit /b 1
)
if not exist "frontend\server.js" (
    color 0C
    echo [错误] 未找到用户前端服务文件: frontend\server.js
    echo.
    pause
    exit /b 1
)
if not exist "admin-frontend\server.js" (
    color 0C
    echo [错误] 未找到管理后台服务文件: admin-frontend\server.js
    echo.
    pause
    exit /b 1
)
echo [成功] 所有必要文件检查通过
echo.

:: ========== 端口检查 ==========
echo [检查] 正在检查端口占用情况...
echo.

netstat -ano | findstr ":8080" | findstr "LISTENING" >nul
if not errorlevel 1 (
    echo [警告] 端口8080已被占用，正在尝试停止旧服务...
    call 停止服务.bat >nul 2>&1
    timeout /t 2 /nobreak >nul
) else (
    echo [成功] 端口8080可用
)

netstat -ano | findstr ":5000" | findstr "LISTENING" >nul
if not errorlevel 1 (
    echo [警告] 端口5000已被占用，正在尝试停止旧服务...
    call 停止服务.bat >nul 2>&1
    timeout /t 2 /nobreak >nul
) else (
    echo [成功] 端口5000可用
)

netstat -ano | findstr ":5001" | findstr "LISTENING" >nul
if not errorlevel 1 (
    echo [警告] 端口5001已被占用，正在尝试停止旧服务...
    call 停止服务.bat >nul 2>&1
    timeout /t 2 /nobreak >nul
) else (
    echo [成功] 端口5001可用
)
echo.

:: ========== 启动服务 ==========
echo ╔════════════════════════════════════════════════════════════╗
echo ║                      启动服务中...                         ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

:: 启动后端服务
echo [1/3] 启动后端服务 (端口 8080)...
cd backend
if exist backend.log del backend.log
start /min cmd /c "java -jar cat-rescue.jar --spring.profiles.active=prod > backend.log 2>&1"
cd ..
echo       等待后端服务启动...
timeout /t 8 /nobreak >nul

:: 检查后端是否启动成功
netstat -ano | findstr ":8080" | findstr "LISTENING" >nul
if errorlevel 1 (
    color 0C
    echo [失败] 后端服务启动失败！
    echo        请查看日志: backend\backend.log
    echo.
    pause
    exit /b 1
) else (
    echo [成功] 后端服务启动成功
)
echo.

:: 启动用户前端
echo [2/3] 启动用户前端 (端口 5000)...
cd frontend
if exist frontend.log del frontend.log
start /min cmd /c "node server.js > frontend.log 2>&1"
cd ..
echo       等待用户前端启动...
timeout /t 3 /nobreak >nul

:: 检查用户前端是否启动成功
netstat -ano | findstr ":5000" | findstr "LISTENING" >nul
if errorlevel 1 (
    color 0C
    echo [失败] 用户前端启动失败！
    echo        请查看日志: frontend\frontend.log
    echo.
    pause
    exit /b 1
) else (
    echo [成功] 用户前端启动成功
)
echo.

:: 启动管理后台
echo [3/3] 启动管理后台 (端口 5001)...
cd admin-frontend
if exist admin.log del admin.log
start /min cmd /c "node server.js > admin.log 2>&1"
cd ..
echo       等待管理后台启动...
timeout /t 3 /nobreak >nul

:: 检查管理后台是否启动成功
netstat -ano | findstr ":5001" | findstr "LISTENING" >nul
if errorlevel 1 (
    color 0C
    echo [失败] 管理后台启动失败！
    echo        请查看日志: admin-frontend\admin.log
    echo.
    pause
    exit /b 1
) else (
    echo [成功] 管理后台启动成功
)
echo.

:: ========== 启动完成 ==========
color 0A
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║                                                            ║
echo ║                  ✓ 所有服务启动成功！                     ║
echo ║                                                            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo ┌────────────────────────────────────────────────────────────┐
echo │  服务地址                                                  │
echo ├────────────────────────────────────────────────────────────┤
echo │  用户前端:  http://localhost:5000                         │
echo │  管理后台:  http://localhost:5001                         │
echo │  后端API:   http://localhost:8080/api                     │
echo │  API文档:   http://localhost:8080/swagger-ui.html         │
echo └────────────────────────────────────────────────────────────┘
echo.
echo ┌────────────────────────────────────────────────────────────┐
echo │  管理员账号                                                │
echo ├────────────────────────────────────────────────────────────┤
echo │  用户名: admin                                             │
echo │  密码:   123456                                            │
echo └────────────────────────────────────────────────────────────┘
echo.
echo ┌────────────────────────────────────────────────────────────┐
echo │  日志文件                                                  │
echo ├────────────────────────────────────────────────────────────┤
echo │  后端日志:     backend\backend.log                        │
echo │  前端日志:     frontend\frontend.log                      │
echo │  管理后台日志: admin-frontend\admin.log                   │
echo └────────────────────────────────────────────────────────────┘
echo.
echo ┌────────────────────────────────────────────────────────────┐
echo │  快捷操作                                                  │
echo ├────────────────────────────────────────────────────────────┤
echo │  查看状态: 运行 "查看状态.bat"                            │
echo │  停止服务: 运行 "停止服务.bat"                            │
echo │  查看日志: 打开对应的log文件                              │
echo └────────────────────────────────────────────────────────────┘
echo.

:: 自动打开浏览器
echo [提示] 正在打开浏览器...
timeout /t 2 /nobreak >nul
start http://localhost:5000
timeout /t 1 /nobreak >nul
start http://localhost:5001/login.html
echo.

echo ════════════════════════════════════════════════════════════
echo  提示: 请保持此窗口打开，关闭将停止所有服务
echo ════════════════════════════════════════════════════════════
echo.
echo 按任意键退出并停止所有服务...
pause >nul

:: 退出时停止服务
echo.
echo [清理] 正在停止所有服务...
call 停止服务.bat >nul 2>&1
echo [完成] 所有服务已停止
timeout /t 2 /nobreak >nul
