# Windows 启动说明（无 Docker）

## 1. 前置条件
- Java 17+
- Node.js 16+
- MySQL 8+（已创建并可访问）

## 2. 初始化数据库
在 `deploy/` 目录执行：
```
init-db.bat
```
完成后会创建 `cat_rescue` 数据库与默认管理员账号（admin / 123456）。

## 3. 一键启动
PowerShell 中执行：
```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\start_windows.ps1
```

## 4. 访问地址
- 用户端：http://localhost:5000
- 管理端：http://localhost:5001
- 后端 API：http://localhost:8080/api

## 5. 可配置环境变量
在启动前可设置：
- `APP_PORT`：后端端口（默认 8080）
- `DB_HOST` / `DB_PORT` / `DB_NAME` / `DB_USER` / `DB_PASS`
- `CORS_ALLOWED_ORIGINS`：允许的前端域名列表
- `API_HOST` / `API_PORT`：前端代理目标（默认 127.0.0.1:8080）
- `SPRING_PROFILES_ACTIVE`：默认 `local`

示例（PowerShell）：
```
$env:DB_HOST = "127.0.0.1"
$env:DB_PASS = "123456"
.\start_windows.ps1
```
