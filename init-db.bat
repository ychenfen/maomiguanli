@echo off
chcp 65001 >nul
title 初始化数据库

echo ========================================
echo     数据库初始化脚本
echo ========================================
echo.

set /p MYSQL_USER=请输入MySQL用户名 (默认root):
if "%MYSQL_USER%"=="" set MYSQL_USER=root

set /p MYSQL_PASSWORD=请输入MySQL密码 (直接回车表示无密码):

echo.
echo [信息] 正在创建数据库...

if "%MYSQL_PASSWORD%"=="" (
    mysql -u%MYSQL_USER% -e "CREATE DATABASE IF NOT EXISTS cat_rescue CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -u%MYSQL_USER% cat_rescue < cat_rescue.sql
) else (
    mysql -u%MYSQL_USER% -p%MYSQL_PASSWORD% -e "CREATE DATABASE IF NOT EXISTS cat_rescue CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -u%MYSQL_USER% -p%MYSQL_PASSWORD% cat_rescue < cat_rescue.sql
)

if errorlevel 1 (
    echo.
    echo [错误] 数据库初始化失败！
    echo 请检查:
    echo   1. MySQL 服务是否已启动
    echo   2. 用户名和密码是否正确
    echo   3. MySQL 是否已添加到系统PATH
    pause
    exit /b 1
)

echo.
echo [成功] 数据库初始化完成！
echo.
echo 默认管理员账号: admin
echo 默认管理员密码: 123456
echo.
pause
