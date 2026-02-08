# PROJECT_AUDIT.md — 项目事实盘点

> 生成时间：2026-02-08  
> 仓库：https://github.com/ychenfen/maomiguanli.git

---

## 1. 目录结构与服务端口

```
maomiguanli/
├── backend/                  # Spring Boot 后端（cat-rescue.jar）
│   ├── cat-rescue.jar        # 可执行 JAR（Spring Boot 3.1.5 + JDK 17）
│   ├── application-local.yml # 本地开发配置
│   ├── application-prod.yml  # 生产配置
│   └── application-override.yml # 安全/静态资源覆盖
├── frontend/                 # 用户端（Vue 3 编译后 SPA）
│   ├── index.html            # SPA 入口
│   ├── server.js             # Node.js 静态服务 + API 代理
│   ├── config.js             # window.__API_BASE__ = '/api'
│   ├── assets/               # Vite 编译产物
│   └── mvp/                  # MVP 测试页面（云养/捐献）
├── admin-frontend/           # 管理端（纯 HTML + JS）
│   ├── login.html            # 登录页
│   ├── layout.html           # 主框架（hash 路由 + 动态加载 pages/）
│   ├── server.js             # Node.js 静态服务 + API 代理
│   ├── config.js             # window.__API_BASE__ = '/api'
│   ├── js/                   # api.js / common.js / components.js
│   ├── css/                  # common.css / layout.css / components.css
│   └── pages/                # 12 个管理页面
├── cat_rescue.sql            # 数据库初始化 SQL（19 张表）
├── uploads/                  # 上传文件目录
└── nginx/                    # Nginx 配置（非必需）
```

| 服务 | 默认端口 | 技术栈 |
|------|----------|--------|
| 后端 | 8080 | Spring Boot 3.1.5 + MyBatis-Plus + MySQL 8 + JWT |
| 用户端 | 5000 | Vue 3 + Element Plus（编译后 SPA） |
| 管理端 | 5001 | 纯 HTML/JS + Node.js 静态服务 |

---

## 2. 后端配置分析

### Profile 与数据库连接

- 使用 `application-local.yml`（本地）/ `application-prod.yml`（生产）
- 数据库：`jdbc:mysql://${DB_HOST:127.0.0.1}:${DB_PORT:3306}/${DB_NAME:cat_rescue}`
- 用户名/密码：`${DB_USER:root}` / `${DB_PASS:123456}`
- 所有配置支持环境变量覆盖

### CORS 配置

```
cors.allowed-origins: http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:5000,http://localhost:5001
```

### 静态资源映射

```
static-locations: classpath:/static/,file:../frontend/,file:../uploads/
```

### JWT 认证

- Secret: `cat-rescue-jwt-secret-key-2024-very-long-string-for-security-purpose-32chars`
- Token 存储：`localStorage`（admin_token / user_token）
- 登录接口：`POST /api/users/login`（form-urlencoded: username + password）

### 公开接口（无需 Token）

```
/api/users/login, /api/users/register
/api/cats/page, /api/cats/{id}, /api/cats/hot, /api/cats/latest, /api/cats/adoptable
/api/dynamics/page, /api/dynamics/{id}, /api/dynamics/list, /api/dynamics/hot
/api/crowdfunding/page, /api/crowdfunding/{id}, /api/crowdfunding/hot
/api/rescue-info/page, /api/rescue-info/{id}, /api/rescue-info/pending, /api/rescue-info/urgent
/api/finance/public, /api/finance/stats, /api/finance/category-stats, /api/finance/monthly-trend
/api/cat-tags/**, /api/university/**, /api/community/hot-topics, /api/community/active-users
/api/files/**, /actuator/health
GET /api/donation/crowdfunding/**, GET /api/comments/dynamic/**
```

---

## 3. 管理端页面列表 + API 清单

| # | 页面文件 | 功能 | 调用的 API（api.js 中定义） | 后端实际路径 | 路径匹配 |
|---|----------|------|---------------------------|-------------|---------|
| 1 | pages/dashboard.html | 数据概览 | dashboard.statistics, userGrowth, activity, popularCats, activeUsers, systemHealth, pendingTasks, recentActivities | /api/admin/dashboard/* | ✅ |
| 2 | pages/users.html | 用户管理 | users.list, detail, changeStatus, changeRole, delete | /api/users/page, /api/users/{id}, /api/users/{id}/status, /api/users/{id}/role | ✅ |
| 3 | pages/cats.html | 猫咪管理 | cats.list, detail, create, update, delete, statistics | /api/cats/page, /api/cats/{id}, /api/cats, /api/cats/{id}/status | ⚠️ statistics→stats |
| 4 | pages/adoptions.html | 领养申请 | adoptions.list, detail, approve, reject, statistics | /api/adoption-applications/page | ❌ 路径不匹配 |
| 5 | pages/verifications.html | 身份认证 | verifications.list, detail, approve, reject, statistics | /api/verification/page | ❌ 路径不匹配 |
| 6 | pages/rescues.html | 救助信息 | rescues.list, detail, updateStatus, statistics | /api/rescue-info/page | ❌ 路径不匹配 |
| 7 | pages/finance.html | 财务管理 | finance.list, statistics | /api/finance/page | ❌ list 路径不匹配 |
| 8 | pages/cat-tags.html | 猫咪标签 | catTags.list, create, update, delete | /api/cat-tags (无 /page) | ⚠️ |
| 9 | pages/universities.html | 高校管理 | universities.list, create, update, delete | /api/university/page | ❌ 复数 vs 单数 |
| 10 | pages/dynamics.html | 社区动态 | dynamics.list, detail, delete, statistics | /api/dynamics/page | ✅ |
| 11 | pages/crowdfunding.html | 众筹管理 | crowdfunding.list, detail, approve, reject, statistics | /api/crowdfunding/page | ⚠️ approve→activate |
| 12 | pages/notifications.html | 通知管理 | notifications.list, detail, send, delete, statistics | /api/notifications/page | ⚠️ send-batch→batch-send |

---

## 4. 用户端页面列表 + 缺失点

### 已有路由（Vue SPA 编译后）

| 路由 | 功能 |
|------|------|
| /home | 首页 |
| /login | 登录 |
| /register | 注册 |
| /cats | 猫咪列表 |
| /cats/:id | 猫咪详情 |
| /adoption | 领养列表 |
| /adoption/apply/:catId | 申请领养 |
| /adoption/my | 我的领养 |
| /community | 社区动态 |
| /community/publish | 发布动态 |
| /community/:id | 动态详情 |
| /rescue | 救助信息 |
| /rescue/publish | 发布救助 |
| /rescue/:id | 救助详情 |
| /user/profile | 个人中心 |
| /notifications | 通知 |

### 缺失页面（需新增）

| 缺失功能 | 需要的页面 |
|----------|-----------|
| **云养宠物** | 云养列表、云养详情、发起云养、我的云养 |
| **捐献/打赏** | 捐献项目列表、捐献项目详情、发起捐献、我的捐献记录、打赏页 |

> 注：frontend/mvp/ 目录下有简单的 MVP 测试页面，但未集成到 SPA 路由中。

---

## 5. 数据库关键表字段列表

### user 表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 用户ID |
| username | varchar(50) UNIQUE | 用户名 |
| password | varchar(255) | BCrypt 加密密码 |
| real_name | varchar(50) | 真实姓名 |
| role | enum(USER,VOLUNTEER,ADMIN,SUPER_ADMIN) | 角色 |
| status | tinyint | 0-禁用 1-正常 |
| phone/email/avatar/college/introduction | - | 基本信息 |

### cat 表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 猫咪ID |
| university_id | bigint FK | 所属高校 |
| name | varchar(50) | 名字 |
| breed/gender/age/color/character | - | 基本信息 |
| cover_image | varchar(500) | 封面图 |
| status | enum(STRAY,OBSERVATION,TREATMENT,ADOPTABLE,ADOPTED) | 状态 |
| health_status | varchar(100) | 健康状态 |
| is_sterilized/is_vaccinated | tinyint | 绝育/疫苗 |
| view_count/like_count/cloud_adoption_count | int | 统计 |

### cloud_adoption 表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 云养ID |
| user_id | bigint FK → user | 云养人 |
| cat_id | bigint FK → cat | 猫咪 |
| adoption_name | varchar(50) | 云养名称 |
| monthly_amount | decimal(10,2) | 每月金额 |
| start_date/end_date | date | 起止日期 |
| is_active | tinyint | 是否活跃 |
| total_amount | decimal(10,2) | 累计金额 |
| message | varchar(200) | 寄语 |
| UNIQUE(user_id, cat_id) | | 每人每猫唯一 |

### donation 表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 捐赠ID |
| user_id | bigint FK | 捐赠人 |
| cat_id | bigint NULL | 猫咪ID（打赏猫咪时） |
| crowdfunding_id | bigint NULL | 众筹项目ID（捐献项目时） |
| amount | decimal(10,2) | 金额 |
| payment_method | varchar(50) | 支付方式 |
| transaction_id | varchar(100) | 第三方交易号 |
| status | enum(PENDING,SUCCESS,FAILED,REFUNDED) | 状态 |
| message | varchar(500) | 留言 |
| is_anonymous | tinyint(1) | 是否匿名 |

> **区分规则**：cat_id 非空 → 打赏猫咪；crowdfunding_id 非空 → 捐献项目

### crowdfunding 表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 众筹ID |
| title | varchar(100) | 标题 |
| description | text | 描述 |
| cat_id | bigint NULL FK | 关联猫咪 |
| creator_id | bigint FK | 发起人 |
| target_amount | decimal(10,2) | 目标金额 |
| current_amount | decimal(10,2) | 当前金额 |
| start_date/end_date | date | 起止日期 |
| status | enum(DRAFT,ACTIVE,COMPLETED,FAILED,CANCELLED) | 状态 |
| cover_image | varchar(500) | 封面 |
| category | varchar(50) | 分类 |

### adoption_application 表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 申请ID |
| cat_id | bigint FK | 猫咪 |
| user_id | bigint FK | 申请人 |
| reason/living_condition/experience | text | 申请信息 |
| status | enum(PENDING,APPROVED,REJECTED,CANCELLED) | 状态 |
| review_user_id | bigint FK | 审核人 |

---

## 6. 当前 Bug 列表（按阻塞程度排序）

### 🔴 阻塞级（阻止核心功能使用）

| # | Bug | 影响 | 原因 |
|---|-----|------|------|
| B1 | `/api/users/page` 返回 500 | 管理端用户列表不可用 | MyBatis 映射 `update_time` 无 setter（UserVO 缺字段） |
| B2 | 管理端 API 路径大面积不匹配 | 领养/认证/救助/财务/高校 5 个页面完全不可用 | api.js 中路径与后端 Controller 不一致 |
| B3 | `/actuator/health` 返回 401 | 健康检查不可用 | SecurityConfig 虽配置了 permitAll 但可能未生效 |

### 🟡 功能级（功能缺失）

| # | Bug | 影响 |
|---|-----|------|
| B4 | 用户端缺少云养宠物页面 | 无法通过 SPA 访问云养功能 |
| B5 | 用户端缺少捐献/打赏页面 | 无法通过 SPA 访问捐献功能 |
| B6 | 管理端 cats.statistics 路径错误 | 猫咪统计不可用（应为 /api/cats/stats） |
| B7 | 管理端 crowdfunding approve/reject 路径错误 | 众筹审批不可用（应为 activate/cancel） |

### 🟢 体验级

| # | Bug | 影响 |
|---|-----|------|
| B8 | 无 Windows 启动脚本 | 需手动逐个启动服务 |
| B9 | 无 health API | 无法快速验证后端是否存活 |
| B10 | 管理端 notifications send-batch 路径错误 | 批量发送通知不可用 |

---

## 7. 后端 API 完整路由表

### UserController `/api/users`
- GET /page — 分页查询（需 ADMIN）
- GET /{id} — 查询用户
- GET /username/{username} — 按用户名查询
- POST /register — 注册
- POST /login — 登录（form-urlencoded）
- PUT /{id} — 更新用户
- PUT /{id}/status — 修改状态
- PUT /{id}/role — 修改角色
- PUT /password — 修改密码
- DELETE /{id} — 删除用户
- GET /profile — 当前用户信息
- PUT /profile — 更新当前用户
- GET /statistics — 统计
- GET /overview — 概览

### CatController `/api/cats`
- GET /page — 分页（公开）
- GET /{id} — 详情（公开）
- POST — 创建
- PUT /{id} — 更新
- DELETE /{id} — 删除
- PUT /{id}/status — 更新状态
- GET /hot, /latest, /adoptable — 列表
- GET /stats, /stats/gender, /stats/status, /stats/breed, /stats/trend — 统计
- GET /overview — 概览

### AdoptionApplicationController `/api/adoption-applications`
- GET /page — 分页
- GET /{id} — 详情
- POST — 提交申请
- POST /{id}/review — 审核（status + rejectReason）
- PUT /{id}/withdraw — 撤回
- GET /my-applications — 我的申请
- GET /statistics — 统计

### CloudAdoptionController `/api/cloud-adoption`
- GET /page — 分页
- GET /{id} — 详情
- GET /my-adoptions — 我的云养
- GET /cat/{catId} — 按猫查询
- POST — 创建（CloudAdoptionDTO: catId, adoptionName, monthlyAmount, startDate, endDate, message）
- PUT /{id} — 更新
- PUT /{id}/cancel — 取消
- PUT /{id}/renew — 续费
- GET /stats — 统计
- GET /check-cat-adopted — 检查是否已云养

### DonationController `/api/donation`
- GET /page — 分页
- GET /{id} — 详情
- GET /my-donations — 我的捐赠
- GET /cat/{catId} — 按猫查询
- GET /crowdfunding/{crowdfundingId} — 按众筹查询
- POST — 创建（DonationDTO: catId, crowdfundingId, amount, message, isAnonymous, paymentMethod, transactionId）
- PUT /{id}/status — 更新状态
- GET /total/cat/{catId}, /total/crowdfunding/{crowdfundingId}, /total/user — 总额
- GET /ranking/cat/{catId}, /ranking/crowdfunding/{crowdfundingId} — 排行
- GET /stats/user, /stats/cat/{catId} — 统计

### CrowdfundingController `/api/crowdfunding`
- GET /page — 分页（公开）
- GET /{id} — 详情（公开）
- GET /my-projects — 我的项目
- GET /cat/{catId} — 按猫查询
- GET /ending-soon, /hot — 列表
- POST — 创建
- PUT /{id} — 更新
- PUT /{id}/activate — 激活
- PUT /{id}/cancel — 取消
- PUT /{id}/progress — 更新进展
- GET /stats/{id}, /stats/creator — 统计

### FinanceController `/api/finance`
- GET /page — 分页
- GET /{id} — 详情
- POST — 创建
- PUT /{id}/approve — 审批
- GET /stats — 统计
- GET /category-stats, /monthly-trend — 分析
- GET /public — 公开列表
- POST /export — 导出

### 其他 Controller
- **RescueInfoController** `/api/rescue-info` — 救助信息 CRUD
- **IdentityVerificationController** `/api/verification` — 身份认证
- **EnhancedVerificationController** `/api/verification/enhanced` — 增强认证
- **UniversityController** `/api/university` — 高校管理
- **CatTagController** `/api/cat-tags` — 标签管理
- **CatDynamicController** `/api/dynamics` — 社区动态
- **CommentController** `/api/comments` — 评论
- **CommunityController** `/api/community` — 社区
- **NotificationController** `/api/notifications` — 通知
- **FileUploadController** `/api/files` — 文件上传
- **AdminDashboardController** `/api/admin/dashboard` — 管理仪表盘

---

## 8. 修复优先级

1. **修复管理端 api.js 路径映射**（解决 B2，影响 5+ 页面）
2. **补充 health API**（解决 B3/B9）
3. **编写 Windows 启动脚本**（解决 B8）
4. **实现云养宠物用户端页面**（解决 B4）
5. **实现捐献/打赏用户端页面**（解决 B5）
