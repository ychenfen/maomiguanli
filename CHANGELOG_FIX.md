# 变更日志 (CHANGELOG_FIX)

## [v1.1.0] - 2026-02-08

### 阶段一：事实盘点与基础修复

#### 新增
- `docs/PROJECT_AUDIT.md` - 完整项目审计报告（目录结构、服务端口、API清单、数据库表结构、bug列表）
- `docs/WINDOWS_DEPLOY.md` - Windows 10/11 无 Docker 部署指南
- `start.bat` - Windows 一键启动脚本（自动检查环境、初始化数据库、启动三个服务）
- `stop.bat` - Windows 一键停止脚本
- `.gitignore` - 排除运行时日志

#### 修复
- **[BUG-001] UserMapper.xml 字段映射错误** - `update_time` 列的 property 写成了 `update_time`（应为 `updateTime`），导致 `GET /api/users/page` 返回 500。修改 jar 内 XML 文件修复。
- **[BUG-002] 管理端 API 路径不匹配** - `api.js` 中多处路径与后端不一致：
  - `adoptions` → `adoption-applications`
  - `verifications` → `verification`
  - `rescues` → `rescue-info`
  - `universities` → `university`
  - `crowdfunding approve/reject` → `activate/cancel`
  - `notifications sendBatch` → `batch-send`
- **[BUG-003] 前端 server.js 缺少 API 代理** - 前端和管理端 server.js 均添加 `/api` 代理到后端 8080，添加 `/uploads` 代理，添加 `/health` 端点。
- **[BUG-004] CORS 配置** - 后端启动时通过环境变量 `CORS_ALLOWED_ORIGINS` 添加前端域名。

---

### 阶段二：云养宠物功能实现

#### 新增页面（用户端 /mvp/）
| 页面 | 路径 | 功能 | 调用 API |
|------|------|------|---------|
| 云养列表 | `/mvp/cloud-adoption-list.html` | 浏览可云养猫咪 | `GET /api/cats/page`, `GET /api/cloud-adoption/stats` |
| 猫咪详情 | `/mvp/cloud-adoption-detail.html` | 查看猫咪/云养详情 | `GET /api/cats/{id}`, `GET /api/cloud-adoption/{id}` |
| 发起云养 | `/mvp/cloud-adoption-order.html` | 选猫+设金额+提交 | `GET /api/cats/page`, `POST /api/cloud-adoption` |
| 我的云养 | `/mvp/cloud-adoption-mine.html` | 查看个人云养记录 | `GET /api/cloud-adoption/my-adoptions`, `GET /api/cloud-adoption/stats` |
| 登录 | `/mvp/mvp-login.html` | 用户登录 | `POST /api/users/login` |

#### 新增页面（管理端）
| 页面 | 路径 | 功能 | 调用 API |
|------|------|------|---------|
| 云养管理 | `#/cloud-adoptions` | 查看所有云养记录 | `GET /api/cloud-adoption/page` |

#### 闭环验证
1. 登录 user1 → 选择猫咪"橘子" → 发起云养（¥30/月，6个月） → 创建成功
2. "我的云养"页面显示刚创建的记录
3. 管理端"云养管理"显示该记录

---

### 阶段三：捐献/打赏功能实现

#### 新增页面（用户端 /mvp/）
| 页面 | 路径 | 功能 | 调用 API |
|------|------|------|---------|
| 捐献项目列表 | `/mvp/donation-projects.html` | 浏览众筹项目 | `GET /api/crowdfunding/page` |
| 项目详情 | `/mvp/donation-detail.html` | 查看项目详情+捐献记录 | `GET /api/crowdfunding/{id}`, `GET /api/donation/crowdfunding/{id}` |
| 发起捐献 | `/mvp/donation-new.html` | 对众筹项目捐献 | `GET /api/crowdfunding/{id}`, `POST /api/donation` |
| 我的捐献 | `/mvp/donation-mine.html` | 查看捐献/打赏记录 | `GET /api/donation/my-donations` |
| 打赏猫咪 | `/mvp/tip.html` | 对猫咪打赏 | `GET /api/cats/page`, `POST /api/donation`, `GET /api/donation/cat/{id}` |

#### 新增页面（管理端）
| 页面 | 路径 | 功能 | 调用 API |
|------|------|------|---------|
| 捐献管理 | `#/donations` | 查看所有捐献/打赏 | `GET /api/donation/page` |

#### 区分规则
- **项目捐献**: `donation` 表中 `crowdfunding_id` 有值
- **猫咪打赏**: `donation` 表中 `cat_id` 有值且 `crowdfunding_id` 为空
- 共用 `donation` 表，前端通过 `crowdfundingId`/`catId` 字段区分显示

#### 闭环验证
1. 登录 → 浏览众筹项目 → 选择"团团皮肤病治疗费用" → 捐献 ¥50 → 成功
2. "我的捐献"显示该记录（类型=项目捐献）
3. 登录 → 选择猫咪"小黑" → 打赏 ¥10 → 成功
4. "我的捐献"显示该记录（类型=猫咪打赏）
5. 管理端"捐献管理"显示所有记录

---

### UI 改进
- 全面重写 `mvp.css` 为现代化 UI（渐变导航栏、卡片阴影、进度条、响应式布局）
- 全面重写 `mvp.js` 增加工具函数（toast、格式化、导航栏渲染、分页组件、登录检查）
- 所有页面统一导航栏和视觉风格
