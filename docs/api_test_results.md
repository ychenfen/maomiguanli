# API 测试结果

## 测试环境
- 后端: localhost:8080 (Java Spring Boot)
- 用户端: localhost:5000 (Node.js)
- 管理端: localhost:5001 (Node.js)
- 数据库: MySQL 8.0, cat_rescue

## 测试账号
- 普通用户: zhangsan / 123456 (role=USER)
- 管理员: admin / 123456 (role=SUPER_ADMIN)

## 管理端页面 API 对齐状态
- dashboard.html → 调用 dashboard API → ✅ 已对齐
- cats.html → 调用 /api/cats/* → ✅ 已对齐
- adoptions.html → 调用 /api/adoption-applications/* → ✅ 已对齐
- crowdfunding.html → 调用 /api/crowdfunding/* → ✅ 已对齐
- users.html → 调用 /api/users/page → ✅ 已修复 (UserMapper.xml update_time→updateTime)
- cloud-adoptions.html → 调用 /api/cloud-adoption/page → ✅ 新增
- donations.html → 调用 /api/donation/page → ✅ 新增

## 闭环测试结果 (2026-02-08)

| 步骤 | 操作 | API | 结果 | 状态 |
|------|------|-----|------|------|
| 1 | 用户登录 | POST /api/users/login | code=200, 返回token | ✅ |
| 2 | 创建云养 | POST /api/cloud-adoption | code=200 (首次) / code=500 已云养(重复) | ✅ |
| 3 | 查看我的云养 | GET /api/cloud-adoption/my-adoptions | code=200, count=2 | ✅ |
| 4 | 捐献众筹项目 | POST /api/donation (crowdfundingId=1) | code=200, data=15 (返回ID) | ✅ |
| 5 | 打赏猫咪 | POST /api/donation (catId=2) | code=200, data=16 (返回ID) | ✅ |
| 6 | 查看我的捐献 | GET /api/donation/my-donations | code=200, count=8 | ✅ |
| 7 | 管理端捐献列表 | GET /api/donation/page | code=200, total=16 | ✅ |
| 8 | 管理端云养列表 | GET /api/cloud-adoption/page | code=200, total=4 | ✅ |

## 注意事项
- donation 创建API返回的 data 是 ID (整数)，不是对象
- cloud-adoption 创建有唯一性约束：同一用户不能重复云养同一只猫
- 数据库用户名: zhangsan, lisi, wangwu, zhaoliu, sunqi (非 user1)
