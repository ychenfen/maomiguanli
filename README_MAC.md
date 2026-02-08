# macOS 启动说明（无 Docker）

## 1. 前置条件
- Java 17+
- Node.js 16+
- MySQL 8+（已创建并可访问）

## 2. 初始化数据库
在 `deploy/` 目录执行（数据库初始化脚本是 Windows bat，需要在 Windows 上执行或手动导入 SQL）：
- 使用 MySQL 客户端导入 `cat_rescue.sql`
- 或在 Windows 上运行 `init-db.bat`

## 3. 一键启动
在 `deploy/` 目录执行：
```
./start_mac.sh
```

## 4. 访问地址
- 用户端：http://localhost:5000
- 管理端：http://localhost:5001
- 后端 API：http://localhost:8080/api

## 5. 可配置环境变量
- `APP_PORT`：后端端口（默认 8080）
- `DB_HOST` / `DB_PORT` / `DB_NAME` / `DB_USER` / `DB_PASS`
- `CORS_ALLOWED_ORIGINS`：允许的前端域名列表
- `API_HOST` / `API_PORT`：前端代理目标（默认 127.0.0.1:8080）
- `SPRING_PROFILES_ACTIVE`：默认 `local`

示例：
```
DB_HOST=127.0.0.1 DB_PASS=123456 ./start_mac.sh
```
