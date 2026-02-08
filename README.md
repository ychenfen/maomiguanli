# 校园流浪猫救助平台

> 一个面向高校的流浪猫信息管理与救助系统，支持猫咪档案、领养申请、云养宠物、众筹捐献、打赏、社区动态等功能。

---

## 目录

- [系统架构](#系统架构)
- [功能总览](#功能总览)
- [环境要求](#环境要求)
- [Windows 快速启动（3 步）](#windows-快速启动3-步)
- [访问地址与测试账号](#访问地址与测试账号)
- [用户端页面导航](#用户端页面导航)
- [管理端页面导航](#管理端页面导航)
- [API 接口文档](#api-接口文档)
- [数据库说明](#数据库说明)
- [项目目录结构](#项目目录结构)
- [常见问题](#常见问题)
- [开发文档](#开发文档)

---

## 系统架构

```
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│   用户端前端      │   │   管理端前端      │   │   MySQL 数据库   │
│   :5000          │   │   :5001          │   │   :3306          │
│   Vue SPA + MVP  │   │   原生 HTML/JS   │   │   cat_rescue     │
└────────┬────────┘   └────────┬────────┘   └────────┬────────┘
         │ /api/*代理           │ /api/*代理           │
         └──────────┬──────────┘                      │
                    ▼                                  │
          ┌─────────────────┐                         │
          │   后端 API       │◄────────────────────────┘
          │   :8080          │
          │   Spring Boot    │
          │   + MyBatis-Plus │
          │   + JWT 认证     │
          └─────────────────┘
```

**关键设计**：用户端和管理端的 Node.js 服务器均内置 `/api/*` 反向代理，前端页面通过相对路径 `/api/xxx` 调用接口，由 Node 层转发到后端 `localhost:8080`，无需配置 CORS 跨域。

---

## 功能总览

| 模块 | 用户端 | 管理端 | 状态 |
|------|--------|--------|------|
| 猫咪档案 | 浏览猫咪列表与详情 | 增删改查猫咪信息 | 已实现 |
| 领养申请 | 提交领养申请 | 审批领养申请 | 已实现 |
| 云养宠物 | 发起云养、我的云养 | 云养记录管理 | 已实现 |
| 众筹项目 | 浏览众筹项目 | 创建/管理众筹 | 已实现 |
| 捐献功能 | 对众筹项目捐献 | 捐献记录管理 | 已实现 |
| 打赏功能 | 对猫咪打赏 | 打赏记录管理 | 已实现 |
| 社区动态 | 浏览/发布动态 | 动态审核管理 | 已实现 |
| 救助信息 | 浏览救助信息 | 发布救助信息 | 已实现 |
| 用户管理 | 注册/登录/个人中心 | 用户列表/角色管理 | 已实现 |
| 实名认证 | 提交认证申请 | 认证审批 | 已实现 |

---

## 环境要求

在 Windows 10/11 上运行本项目，需要安装以下软件：

| 软件 | 最低版本 | 下载地址 | 验证命令 |
|------|---------|---------|---------|
| **JDK** | 17+ | https://adoptium.net/ | `java -version` |
| **Node.js** | 18+ | https://nodejs.org/ | `node -v` |
| **MySQL** | 8.0+ | https://dev.mysql.com/downloads/ | `mysql --version` |

> **注意**：安装时务必勾选"添加到 PATH"选项。MySQL 安装后需要记住 root 密码。

---

## Windows 快速启动（3 步）

### 第 1 步：初始化数据库（仅首次）

打开命令提示符（CMD），进入项目根目录，执行：

```cmd
mysql -u root -p < cat_rescue.sql
```

输入 MySQL root 密码后等待导入完成。或者双击 `init-db.bat` 按提示操作。

> 如果 MySQL root 密码不是 `123456`，需要修改 `start.bat` 中第 16 行的 `MYSQL_PASS` 变量。

### 第 2 步：一键启动

**双击 `start.bat`**

脚本会自动完成以下操作：
1. 检查 Java、Node.js、MySQL 环境
2. 检查数据库是否存在（不存在则自动导入）
3. 启动后端服务（端口 8080）
4. 等待后端就绪
5. 启动用户端前端（端口 5000）
6. 启动管理端前端（端口 5001）
7. 自动打开浏览器

### 第 3 步：访问系统

启动成功后，浏览器会自动打开。如果没有，手动访问以下地址：

| 入口 | 地址 |
|------|------|
| **用户端首页** | http://localhost:5000 |
| **用户端功能页（云养/捐献/打赏）** | http://localhost:5000/mvp/mvp-login.html |
| **管理后台** | http://localhost:5001/login.html |

> **停止服务**：双击 `stop.bat`，或直接关闭所有命令行窗口。

---

## 访问地址与测试账号

### 服务端口

| 服务 | 端口 | 说明 |
|------|------|------|
| 后端 API | 8080 | Spring Boot，所有 `/api/*` 接口 |
| 用户端前端 | 5000 | Vue SPA + MVP 功能页面 |
| 管理端前端 | 5001 | 管理后台 HTML 页面 |
| MySQL | 3306 | 数据库 `cat_rescue` |

### 测试账号

| 角色 | 用户名 | 密码 | 说明 |
|------|--------|------|------|
| 管理员 | admin | 123456 | 管理端全部权限 |
| 普通用户 | zhangsan | 123456 | 用户端所有功能 |
| 普通用户 | lisi | 123456 | 备用测试账号 |

---

## 用户端页面导航

用户端包含两部分：Vue SPA（主站）和 MVP 功能页面（云养/捐献/打赏）。

### Vue SPA 主站（http://localhost:5000）

通过 Vue Router 导航，包含猫咪浏览、领养申请、社区动态、救助信息、个人中心等功能。

### MVP 功能页面

| 功能 | 页面路径 | 说明 |
|------|---------|------|
| 登录 | `/mvp/mvp-login.html` | MVP 功能页面统一登录入口 |
| **云养猫咪列表** | `/mvp/cloud-adoption-list.html` | 浏览所有猫咪，选择发起云养 |
| **猫咪详情** | `/mvp/cloud-adoption-detail.html?id={catId}` | 查看猫咪详细信息和照片 |
| **发起云养** | `/mvp/cloud-adoption-order.html?catId={catId}` | 填写云养信息并提交 |
| **我的云养** | `/mvp/cloud-adoption-mine.html` | 查看个人云养记录和状态 |
| **捐献项目列表** | `/mvp/donation-projects.html` | 浏览众筹项目，查看进度 |
| **捐献项目详情** | `/mvp/donation-detail.html?id={crowdfundingId}` | 项目详情和捐献排行榜 |
| **发起捐献** | `/mvp/donation-new.html?crowdfundingId={id}` | 填写捐献金额和留言 |
| **我的捐献/打赏** | `/mvp/donation-mine.html` | 查看所有捐献和打赏记录 |
| **打赏猫咪** | `/mvp/tip.html` | 选择猫咪进行打赏 |

### 用户端操作流程

```
登录 → 云养猫咪列表 → 选择猫咪 → 发起云养 → 我的云养（查看记录）
                                ↓
登录 → 捐献项目列表 → 选择项目 → 发起捐献 → 我的捐献（查看记录）
                                ↓
登录 → 打赏猫咪 → 选择猫咪 → 填写金额 → 我的捐献（查看记录）
```

---

## 管理端页面导航

管理端地址：http://localhost:5001/login.html

登录后进入 `layout.html`，左侧菜单导航：

| 菜单 | 页面路径 | 功能 |
|------|---------|------|
| 仪表盘 | `#/dashboard` | 系统数据概览 |
| 猫咪管理 | `#/cats` | 猫咪信息增删改查 |
| 领养申请 | `#/adoption-applications` | 审批领养申请 |
| 众筹管理 | `#/crowdfunding` | 创建/管理众筹项目 |
| 云养管理 | `#/cloud-adoptions` | 查看所有云养记录 |
| 捐献管理 | `#/donations` | 查看所有捐献/打赏记录 |
| 用户管理 | `#/users` | 用户列表和角色管理 |
| 动态管理 | `#/dynamics` | 社区动态审核 |
| 救助管理 | `#/rescues` | 救助信息管理 |
| 认证管理 | `#/verifications` | 实名认证审批 |
| 财务管理 | `#/finance` | 财务数据统计 |
| 通知管理 | `#/notifications` | 系统通知管理 |

---

## API 接口文档

### 认证方式

所有需要认证的接口，在请求头中携带 JWT Token：

```
Authorization: Bearer <token>
```

### 获取 Token

```bash
# 用户登录
curl -s -X POST "http://localhost:8080/api/users/login?username=zhangsan&password=123456"

# 管理员登录
curl -s -X POST "http://localhost:8080/api/users/login?username=admin&password=123456"
```

> **注意**：登录接口使用 Query 参数（`?username=xxx&password=xxx`），不是 JSON Body。

### 核心 API 一览

| 模块 | 方法 | 路径 | 说明 | 认证 |
|------|------|------|------|------|
| 猫咪 | GET | `/api/cats/page?page=1&size=10` | 猫咪列表 | 否 |
| 猫咪 | GET | `/api/cats/{id}` | 猫咪详情 | 否 |
| 云养 | POST | `/api/cloud-adoption` | 创建云养 | 是 |
| 云养 | GET | `/api/cloud-adoption/my-adoptions` | 我的云养 | 是 |
| 云养 | GET | `/api/cloud-adoption/page?page=1&size=10` | 云养列表（管理） | 是 |
| 云养 | GET | `/api/cloud-adoption/stats` | 云养统计 | 是 |
| 众筹 | GET | `/api/crowdfunding/page?page=1&size=10` | 众筹列表 | 否 |
| 众筹 | GET | `/api/crowdfunding/{id}` | 众筹详情 | 否 |
| 捐献 | POST | `/api/donation` | 创建捐献/打赏 | 是 |
| 捐献 | GET | `/api/donation/my-donations` | 我的捐献 | 是 |
| 捐献 | GET | `/api/donation/page?page=1&size=10` | 捐献列表（管理） | 是 |
| 捐献 | GET | `/api/donation/cat/{catId}` | 猫咪打赏记录 | 否 |
| 捐献 | GET | `/api/donation/crowdfunding/{id}` | 项目捐献记录 | 否 |
| 捐献 | GET | `/api/donation/ranking/cat/{catId}` | 猫咪打赏排行 | 否 |
| 捐献 | GET | `/api/donation/stats/user` | 用户捐献统计 | 是 |
| 领养 | POST | `/api/adoption-applications` | 提交领养申请 | 是 |
| 领养 | GET | `/api/adoption-applications/page` | 领养申请列表 | 是 |
| 用户 | POST | `/api/users/register` | 用户注册 | 否 |
| 用户 | GET | `/api/users/page?page=1&size=10` | 用户列表（管理） | 是 |
| 动态 | GET | `/api/dynamic/page?page=1&size=10` | 动态列表 | 否 |
| 救助 | GET | `/api/rescue/page?page=1&size=10` | 救助信息列表 | 否 |

### 快速验证（复制即用）

```bash
# 1. 登录获取 Token
TOKEN=$(curl -s -X POST "http://localhost:8080/api/users/login?username=zhangsan&password=123456" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['token'])")

# 2. 创建云养
curl -s -X POST "http://localhost:8080/api/cloud-adoption" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"catId":1,"adoptionName":"陪伴橘子","monthlyAmount":30,"startDate":"2026-02-08","endDate":"2026-08-08","message":"加油"}'

# 3. 查看我的云养
curl -s "http://localhost:8080/api/cloud-adoption/my-adoptions" -H "Authorization: Bearer $TOKEN"

# 4. 对众筹项目捐献
curl -s -X POST "http://localhost:8080/api/donation" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"crowdfundingId":1,"amount":50,"message":"加油","paymentMethod":"WECHAT","isAnonymous":false}'

# 5. 对猫咪打赏
curl -s -X POST "http://localhost:8080/api/donation" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"catId":3,"amount":15,"message":"花花真可爱","paymentMethod":"ALIPAY","isAnonymous":false}'

# 6. 查看我的捐献/打赏
curl -s "http://localhost:8080/api/donation/my-donations" -H "Authorization: Bearer $TOKEN"
```

> 更多测试用例见 `tests/manual/curl_examples.md`。

---

## 数据库说明

数据库名：`cat_rescue`，使用 `cat_rescue.sql` 初始化，包含建表语句和测试数据。

### 核心表

| 表名 | 说明 | 关键字段 |
|------|------|---------|
| `user` | 用户表 | id, username, password, role, status |
| `cat` | 猫咪表 | id, name, breed, gender, status, cover_image |
| `adoption_application` | 领养申请 | id, user_id, cat_id, status |
| `cloud_adoption` | 云养记录 | id, user_id, cat_id, monthly_amount, is_active |
| `crowdfunding` | 众筹项目 | id, title, target_amount, current_amount, status |
| `donation` | 捐献/打赏 | id, user_id, cat_id, crowdfunding_id, amount, status |
| `dynamic` | 社区动态 | id, user_id, content, status |
| `rescue` | 救助信息 | id, title, location, status |
| `verification` | 实名认证 | id, user_id, status |
| `notification` | 通知 | id, user_id, title, is_read |

### 捐献与打赏的区分规则

`donation` 表同时存储捐献和打赏记录，通过字段区分：

| 场景 | `crowdfunding_id` | `cat_id` | 说明 |
|------|-------------------|----------|------|
| 项目捐献 | 有值 | 可为空 | 面向众筹项目的捐献 |
| 猫咪打赏 | 空 | 有值 | 面向猫咪的打赏 |

---

## 项目目录结构

```
maomiguanli/
├── backend/                    # 后端服务
│   ├── cat-rescue.jar          # Spring Boot 可执行 jar
│   └── application-local.yml   # 本地环境配置
├── frontend/                   # 用户端前端
│   ├── server.js               # Node.js 服务器（含 API 代理）
│   ├── config.js               # 前端配置
│   ├── index.html              # Vue SPA 入口
│   ├── assets/                 # Vue 编译后的静态资源
│   ├── mvp/                    # MVP 功能页面（云养/捐献/打赏）
│   │   ├── mvp-login.html      # 登录页
│   │   ├── mvp.js              # 公共 JS 工具库
│   │   ├── mvp.css             # 公共样式
│   │   ├── cloud-adoption-*.html  # 云养相关页面（4个）
│   │   ├── donation-*.html     # 捐献相关页面（4个）
│   │   └── tip.html            # 打赏页面
│   └── uploads/                # 静态资源（猫咪图片等）
├── admin-frontend/             # 管理端前端
│   ├── server.js               # Node.js 服务器（含 API 代理）
│   ├── login.html              # 登录页
│   ├── layout.html             # 管理端主框架
│   ├── js/                     # 公共 JS（api.js, common.js）
│   └── pages/                  # 管理端各功能页面
│       ├── dashboard.html      # 仪表盘
│       ├── cats.html           # 猫咪管理
│       ├── cloud-adoptions.html # 云养管理
│       ├── donations.html      # 捐献管理
│       └── ...                 # 其他管理页面
├── uploads/                    # 上传文件目录（头像/猫咪图片）
├── cat_rescue.sql              # 数据库初始化脚本
├── start.bat                   # Windows 一键启动（推荐）
├── stop.bat                    # Windows 停止服务
├── init-db.bat                 # 数据库初始化（交互式）
├── docs/                       # 项目文档
│   ├── PROJECT_AUDIT.md        # 项目事实盘点
│   ├── WINDOWS_DEPLOY.md       # Windows 部署详细文档
│   └── DELIVERY_REPORT.md      # 交付报告
├── tests/manual/               # 手动测试用例
│   └── curl_examples.md        # curl 测试命令集
└── CHANGELOG_FIX.md            # 变更日志
```

---

## 常见问题

### Q: 双击 start.bat 后闪退？

1. 右键 `start.bat` → 选择"编辑"，检查 `MYSQL_PASS` 是否与你的 MySQL 密码一致
2. 打开 CMD，`cd` 到项目目录，手动执行 `start.bat` 查看错误信息
3. 确认 `java -version`、`node -v`、`mysql --version` 都能正常输出

### Q: 后端启动超时？

1. 检查 MySQL 服务是否已启动：`net start mysql`
2. 检查数据库是否已初始化：`mysql -u root -p -e "USE cat_rescue; SHOW TABLES;"`
3. 查看后端日志：`backend\backend.log` 或 `backend\logs\cat-rescue.log`

### Q: 页面打开后显示空白或 404？

1. Vue SPA 主站（`:5000`）需要后端 API 正常运行才能加载数据
2. MVP 功能页面需要先在 `/mvp/mvp-login.html` 登录
3. 确认后端 API 可访问：浏览器打开 `http://localhost:8080/api/cats/page?page=1&size=1`

### Q: 端口被占用？

```cmd
REM 查看占用端口的进程
netstat -ano | findstr ":8080"
netstat -ano | findstr ":5000"

REM 强制结束进程（替换 PID）
taskkill /F /PID <PID>
```

或直接运行 `stop.bat` 停止所有服务后重新启动。

### Q: MySQL 密码不是 123456？

编辑 `start.bat`，修改第 16 行：

```bat
set MYSQL_PASS=你的密码
```

### Q: 如何只启动某个服务？

```cmd
REM 只启动后端
cd backend
java -jar cat-rescue.jar --spring.profiles.active=local

REM 只启动用户端前端
cd frontend
node server.js

REM 只启动管理端前端
cd admin-frontend
node server.js
```

---

## 开发文档

| 文档 | 路径 | 说明 |
|------|------|------|
| 项目事实盘点 | `docs/PROJECT_AUDIT.md` | 完整的项目状态分析 |
| Windows 部署 | `docs/WINDOWS_DEPLOY.md` | 详细的部署步骤 |
| 交付报告 | `docs/DELIVERY_REPORT.md` | 功能实现和验证报告 |
| 测试用例 | `tests/manual/curl_examples.md` | 可执行的 API 测试命令 |
| 变更日志 | `CHANGELOG_FIX.md` | 所有修复和新增功能记录 |

### 技术栈

| 层 | 技术 |
|------|------|
| 后端框架 | Spring Boot 3.1.5 |
| ORM | MyBatis-Plus 3.5.7 |
| 认证 | Spring Security + JWT |
| 数据库 | MySQL 8.0 |
| 用户端前端 | Vue 3 + Element Plus + Pinia |
| 管理端前端 | 原生 HTML/JS + Element UI CDN |
| 前端服务器 | Node.js + Express |
| 构建工具 | Vite |
