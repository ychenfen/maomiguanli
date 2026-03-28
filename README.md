# 校园流浪动物救助系统部署包

这个目录是可直接交付的运行包，包含：

- `backend/`：Spring Boot 后端与静态资源
- `frontend/`：用户前端
- `admin-frontend/`：管理后台
- `cat_rescue.sql`：当前数据库导出
- `init-db.bat`：Windows 数据库初始化脚本
- `start_windows.ps1`：Windows 全量启动脚本
- `一键启动.bat`：Windows 快速启动脚本
- `start_mac.sh`：Mac 启动脚本

## 默认访问地址

- 用户端：`http://localhost:5000`
- 管理后台：`http://localhost:5001`
- 后端接口：`http://localhost:8080/api`

## 默认账号

- 管理员：`admin / 123456`
- 普通用户：`zhangsan / 123456`

## 推荐启动方式

### Windows

优先看 [README_WINDOWS.md](/Users/yuchenxu/Desktop/猫咪领养系统-部署包/deploy/README_WINDOWS.md)。

如果你要同时启动用户端、管理后台和后端，推荐用：

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\start_windows.ps1
```

如果你只想快速打开用户端，可以直接双击：

```text
一键启动.bat
```

### Mac

```bash
chmod +x start_mac.sh
./start_mac.sh
```

## 首次部署

1. 安装 `Java 17+`、`Node.js 16+`、`MySQL 8+`。
2. 进入 `deploy/` 目录。
3. 运行 `init-db.bat` 导入 `cat_rescue.sql`。
4. 启动系统。
5. 打开浏览器访问前台或管理后台。

## 日志位置

- 后端日志：`backend/backend.log`
- 用户前端日志：`frontend/frontend.log`
- 管理后台日志：`admin-frontend/admin.log`

## 说明

- 这个部署包已经包含一份最新数据库导出，可直接用于 Windows 初始化。
- 管理后台和用户端默认都通过本机后端 `8080` 端口访问接口。
- 如果要改数据库或端口，请同步修改环境变量后再启动。
