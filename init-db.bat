@echo off
chcp 65001 >nul 2>&1
title 校园流浪猫救助平台 - 数据库初始化
color 0B

echo.
echo  ========================================================
echo     校园流浪猫救助平台 - 数据库初始化
echo  ========================================================
echo.
echo  本脚本将创建数据库 cat_rescue 并导入表结构和测试数据。
echo  如果数据库已存在，将会被重建（已有数据会丢失）。
echo.

REM 切换到脚本所在目录
cd /d "%~dp0"

REM 检查 SQL 文件
if not exist "cat_rescue.sql" (
    echo  [ERROR] 未找到 cat_rescue.sql 文件！
    echo          请确保该文件在项目根目录下。
    pause
    exit /b 1
)

REM 获取 MySQL 连接信息
echo  请输入 MySQL 连接信息：
echo.
set /p MYSQL_USER="  MySQL 用户名（默认 root）: "
if "%MYSQL_USER%"=="" set MYSQL_USER=root

set /p MYSQL_PASS="  MySQL 密码（默认 123456）: "
if "%MYSQL_PASS%"=="" set MYSQL_PASS=123456

set /p MYSQL_HOST="  MySQL 地址（默认 127.0.0.1）: "
if "%MYSQL_HOST%"=="" set MYSQL_HOST=127.0.0.1

set /p MYSQL_PORT="  MySQL 端口（默认 3306）: "
if "%MYSQL_PORT%"=="" set MYSQL_PORT=3306

echo.
echo  --------------------------------------------------------
echo  连接信息: %MYSQL_USER%@%MYSQL_HOST%:%MYSQL_PORT%
echo  --------------------------------------------------------
echo.

REM 测试连接
echo  [1/3] 测试 MySQL 连接...
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h%MYSQL_HOST% -P%MYSQL_PORT% -e "SELECT 1" >nul 2>&1
if errorlevel 1 (
    echo.
    echo  [ERROR] MySQL 连接失败！
    echo          请检查：
    echo          1. MySQL 服务是否已启动
    echo          2. 用户名和密码是否正确
    echo          3. mysql 命令是否在 PATH 中
    echo.
    echo          启动 MySQL 服务: net start mysql
    echo.
    pause
    exit /b 1
)
echo        [OK] 连接成功
echo.

REM 确认操作
echo  [2/3] 准备导入数据库...
echo.
echo  [WARN] 如果数据库 cat_rescue 已存在，其中的数据将被覆盖！
echo.
set /p CONFIRM="  确认继续？(Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo.
    echo  操作已取消。
    pause
    exit /b 0
)
echo.

REM 导入数据库
echo  [3/3] 正在导入数据库（可能需要几秒钟）...
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h%MYSQL_HOST% -P%MYSQL_PORT% < cat_rescue.sql
if errorlevel 1 (
    echo.
    echo  [ERROR] 数据库导入失败！
    echo          请检查 cat_rescue.sql 文件是否完整。
    pause
    exit /b 1
)

REM 验证
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -h%MYSQL_HOST% -P%MYSQL_PORT% -e "USE cat_rescue; SELECT COUNT(*) AS table_count FROM information_schema.tables WHERE table_schema='cat_rescue';" 2>nul
echo.

echo  ========================================================
echo     数据库初始化完成！
echo  ========================================================
echo.
echo  数据库名:   cat_rescue
echo  连接地址:   %MYSQL_HOST%:%MYSQL_PORT%
echo.
echo  测试账号:
echo    管理员:    admin / 123456
echo    普通用户:  zhangsan / 123456
echo    普通用户:  lisi / 123456
echo.
echo  下一步:     运行 start.bat 启动系统
echo.
echo  ========================================================
echo.
pause
