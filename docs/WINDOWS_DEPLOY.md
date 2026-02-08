# Windows 部署指南

## 环境要求

| 组件 | 版本要求 | 下载地址 |
|------|---------|---------|
| JDK | 17+ | https://adoptium.net/ |
| Node.js | 18+ | https://nodejs.org/ |
| MySQL | 8.0+ | https://dev.mysql.com/downloads/ |

## 快速启动

### 第一步：初始化数据库

打开 MySQL 命令行或 Navicat，执行项目根目录下的 `cat_rescue.sql` 文件：

```bash
mysql -u root -p123456 < cat_rescue.sql
```

如果 MySQL 用户名/密码不同，请修改 `start.bat` 中的配置区。

### 第二步：一键启动

双击运行 `start.bat`，脚本会自动完成以下操作：

1. 检查 Java、Node.js、MySQL 环境
2. 检查并初始化数据库（如不存在）
3. 启动后端 Spring Boot 服务（端口 8080）
4. 启动用户端前端（端口 5000）
5. 启动管理端前端（端口 5001）
6. 自动打开浏览器

### 第三步：访问系统

| 服务 | 地址 | 说明 |
|------|------|------|
| 用户端 | http://localhost:5000 | 普通用户使用 |
| 管理后台 | http://localhost:5001 | 管理员使用 |
| 后端 API | http://localhost:8080 | API 接口 |

### 默认账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 超级管理员 | admin | 123456 |
| 测试用户 | user1 | 123456 |

## 停止服务

双击运行 `stop.bat` 即可停止所有服务。

## 自定义配置

编辑 `start.bat` 顶部的配置区可修改以下参数：

```batch
set MYSQL_HOST=127.0.0.1
set MYSQL_PORT=3306
set MYSQL_DB=cat_rescue
set MYSQL_USER=root
set MYSQL_PASS=123456
set BACKEND_PORT=8080
set USER_PORT=5000
set ADMIN_PORT=5001
```

## 后端配置文件

后端使用 `backend/application-local.yml` 作为本地配置文件，主要配置项包括数据库连接、CORS 允许域名、文件上传路径等。如需修改，直接编辑该文件即可。

## 常见问题

### Q: 端口被占用怎么办？

修改 `start.bat` 中对应的端口号，或先运行 `stop.bat` 停止旧服务。

### Q: 后端启动失败？

检查 MySQL 是否已启动，数据库 `cat_rescue` 是否已创建。查看后端窗口的错误日志。

### Q: 前端页面空白？

确认后端已成功启动（访问 http://localhost:8080/api/cats/page?page=1&size=1 应返回 JSON）。
