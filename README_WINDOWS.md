# Windows 部署教程

这份教程对应当前 `deploy/` 目录里的实际脚本和端口，按下面做可以在 Windows 10/11 上把系统跑起来。

## 1. 准备环境

需要先安装并加入 PATH：

- `Java 17+`
- `Node.js 16+`
- `MySQL 8+`

建议安装完成后在 PowerShell 里先检查：

```powershell
java -version
node -v
mysql --version
```

## 2. 解压目录

把压缩包解压到任意目录，例如：

```text
D:\animal-rescue\deploy
```

后面的命令都默认在这个 `deploy/` 目录里执行。

## 3. 初始化数据库

### 方式一：直接用脚本

双击：

```text
init-db.bat
```

脚本会做两件事：

- 创建 `cat_rescue` 数据库
- 导入当前包内的 `cat_rescue.sql`

导入成功后，默认管理员账号是：

- 用户名：`admin`
- 密码：`123456`

### 方式二：手动导入

如果你更习惯命令行，可以在 PowerShell 里执行：

```powershell
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS cat_rescue CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -uroot cat_rescue < .\cat_rescue.sql
```

如果 MySQL 有密码：

```powershell
mysql -uroot -p -e "CREATE DATABASE IF NOT EXISTS cat_rescue CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -uroot -p cat_rescue < .\cat_rescue.sql
```

## 4. 启动系统

### 推荐方式：启动完整三套服务

这个方式会同时启动：

- 后端 `8080`
- 用户前端 `5000`
- 管理后台 `5001`

在 PowerShell 中执行：

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\start_windows.ps1
```

启动成功后访问：

- 用户端：`http://localhost:5000`
- 管理后台：`http://localhost:5001`
- 后端接口：`http://localhost:8080/api`

### 快速方式：只启动用户端和后端

如果你只是想快速看前台页面，可以直接双击：

```text
一键启动.bat
```

注意：

- 这个脚本默认启动后端和用户前端
- 管理后台不在这个脚本里启动
- 需要管理后台时还是用 `start_windows.ps1`

## 5. 默认账号

### 管理后台

- 用户名：`admin`
- 密码：`123456`

### 普通用户

- 用户名：`zhangsan`
- 密码：`123456`

## 6. 常用环境变量

如果你的 Windows 机器数据库密码、端口或地址不是默认值，可以在启动前先设置：

```powershell
$env:DB_HOST = "127.0.0.1"
$env:DB_PORT = "3306"
$env:DB_NAME = "cat_rescue"
$env:DB_USER = "root"
$env:DB_PASS = "123456"
$env:APP_PORT = "8080"
$env:API_HOST = "127.0.0.1"
$env:API_PORT = "8080"
$env:SPRING_PROFILES_ACTIVE = "local"
```

然后再执行：

```powershell
.\start_windows.ps1
```

## 7. 日志怎么看

启动后如果页面打不开，先看这三个日志：

- 后端：`backend\backend.log`
- 用户前端：`frontend\frontend.log`
- 管理后台：`admin-frontend\admin.log`

## 8. 常见问题

### 1. 数据库初始化失败

优先检查：

- MySQL 服务是否已经启动
- `mysql` 命令是否在 PATH 里
- 用户名和密码是否正确

### 2. 前台能开，后台打不开

说明你可能用了 `一键启动.bat`。  
要同时启动管理后台，请改用：

```powershell
.\start_windows.ps1
```

### 3. 8080 / 5000 / 5001 端口被占用

先关闭旧进程，再重新启动。  
如果要改端口，可以先设置环境变量再启动。

### 4. 后端起来了但页面没有数据

通常是数据库没导入或配置不对，重点检查：

- `cat_rescue` 数据库是否存在
- `DB_HOST / DB_PORT / DB_USER / DB_PASS` 是否正确
- `backend\backend.log` 里有没有数据库连接报错

## 9. 交付时建议一起带上

给 Windows 用户时，建议把这几项一起提供：

- `deploy/` 整个目录
- `README_WINDOWS.md`
- `cat_rescue.sql`
- Java / Node / MySQL 的安装说明或下载地址

这样对方按教程一步步做就能直接跑起来。
