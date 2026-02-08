# 手动测试用例 - curl 命令

> 所有命令假设后端运行在 `http://localhost:8080`，用户端运行在 `http://localhost:5000`，管理端运行在 `http://localhost:5001`。

## 0. 获取 Token（前置步骤）

```bash
# 用户登录（获取 user token）
TOKEN=$(curl -s -X POST "http://localhost:8080/api/users/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=zhangsan&password=123456" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['token'])")
echo "TOKEN=$TOKEN"

# 管理员登录
ADMIN_TOKEN=$(curl -s -X POST "http://localhost:8080/api/users/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=admin&password=123456" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['token'])")
echo "ADMIN_TOKEN=$ADMIN_TOKEN"
```

---

## 1. 云养宠物功能测试

### 1.1 查看猫咪列表
```bash
curl -s "http://localhost:8080/api/cats/page?page=1&size=5" | python3 -m json.tool
```
**预期**: code=200, data.records 包含猫咪列表

### 1.2 创建云养
```bash
curl -s -X POST "http://localhost:8080/api/cloud-adoption" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "catId": 1,
    "adoptionName": "陪伴橘子",
    "monthlyAmount": 30.00,
    "startDate": "2026-02-08",
    "endDate": "2026-08-08",
    "message": "希望橘子健康快乐"
  }' | python3 -m json.tool
```
**预期**: code=200, 返回创建的云养记录

### 1.3 查看我的云养
```bash
curl -s "http://localhost:8080/api/cloud-adoption/my-adoptions" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool
```
**预期**: code=200, data 数组中包含刚创建的记录

### 1.4 查看云养统计
```bash
curl -s "http://localhost:8080/api/cloud-adoption/stats" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool
```
**预期**: code=200, data 包含 activeCount, totalAmount 等

### 1.5 查看云养详情
```bash
curl -s "http://localhost:8080/api/cloud-adoption/1" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool
```
**预期**: code=200, data 包含完整云养信息

### 1.6 管理端查看云养列表（分页）
```bash
curl -s "http://localhost:8080/api/cloud-adoption/page?page=1&size=10" \
  -H "Authorization: Bearer $ADMIN_TOKEN" | python3 -m json.tool
```
**预期**: code=200, data.records 包含所有用户的云养记录

---

## 2. 捐献功能测试

### 2.1 查看众筹项目列表
```bash
curl -s "http://localhost:8080/api/crowdfunding/page?page=1&size=5" | python3 -m json.tool
```
**预期**: code=200, data.records 包含众筹项目

### 2.2 查看众筹项目详情
```bash
curl -s "http://localhost:8080/api/crowdfunding/1" | python3 -m json.tool
```
**预期**: code=200, data 包含项目详情（title, targetAmount, currentAmount 等）

### 2.3 对众筹项目捐献
```bash
curl -s -X POST "http://localhost:8080/api/donation" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "crowdfundingId": 1,
    "amount": 50.00,
    "message": "加油！希望团团早日康复",
    "paymentMethod": "WECHAT",
    "isAnonymous": false
  }' | python3 -m json.tool
```
**预期**: code=200, 返回创建的捐献记录

### 2.4 查看我的捐献记录
```bash
curl -s "http://localhost:8080/api/donation/my-donations" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool
```
**预期**: code=200, data 包含刚创建的捐献记录

---

## 3. 打赏功能测试

### 3.1 对猫咪打赏
```bash
curl -s -X POST "http://localhost:8080/api/donation" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "catId": 2,
    "amount": 10.00,
    "message": "小黑真可爱！",
    "paymentMethod": "ALIPAY",
    "isAnonymous": true
  }' | python3 -m json.tool
```
**预期**: code=200, 返回打赏记录（catId=2, isAnonymous=true）

### 3.2 查看猫咪的打赏记录
```bash
curl -s "http://localhost:8080/api/donation/cat/2" | python3 -m json.tool
```
**预期**: code=200, data 包含对猫咪2的打赏记录

### 3.3 查看众筹项目的捐献记录
```bash
curl -s "http://localhost:8080/api/donation/crowdfunding/1" | python3 -m json.tool
```
**预期**: code=200, data 包含项目1的所有捐献记录

---

## 4. 管理端捐献管理
```bash
curl -s "http://localhost:8080/api/donation/page?page=1&size=10" \
  -H "Authorization: Bearer $ADMIN_TOKEN" | python3 -m json.tool
```
**预期**: code=200, data.records 包含所有捐献/打赏记录

---

## 5. 闭环验证流程

完整闭环测试（一条命令跑完）：

```bash
#!/bin/bash
echo "=== 1. 登录 ==="
TOKEN=$(curl -s -X POST "http://localhost:8080/api/users/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=zhangsan&password=123456" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['token'])")
echo "Token: ${TOKEN:0:20}..."

echo "=== 2. 创建云养 ==="
curl -s -X POST "http://localhost:8080/api/cloud-adoption" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"catId":1,"adoptionName":"测试云养","monthlyAmount":20,"startDate":"2026-02-08","endDate":"2026-08-08","message":"测试"}' \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'code={d[\"code\"]} id={d.get(\"data\",{}).get(\"id\",\"?\")}')"

echo "=== 3. 查看我的云养 ==="
curl -s "http://localhost:8080/api/cloud-adoption/my-adoptions" \
  -H "Authorization: Bearer $TOKEN" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'code={d[\"code\"]} count={len(d.get(\"data\",[]))}')"

echo "=== 4. 捐献众筹项目 ==="
curl -s -X POST "http://localhost:8080/api/donation" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"crowdfundingId":1,"amount":25,"message":"测试捐献","paymentMethod":"WECHAT","isAnonymous":false}' \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'code={d[\"code\"]} id={d.get(\"data\",{}).get(\"id\",\"?\")}')"

echo "=== 5. 打赏猫咪 ==="
curl -s -X POST "http://localhost:8080/api/donation" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"catId":2,"amount":5,"message":"测试打赏","paymentMethod":"ALIPAY","isAnonymous":true}' \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'code={d[\"code\"]} id={d.get(\"data\",{}).get(\"id\",\"?\")}')"

echo "=== 6. 查看我的捐献/打赏 ==="
curl -s "http://localhost:8080/api/donation/my-donations" \
  -H "Authorization: Bearer $TOKEN" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'code={d[\"code\"]} count={len(d.get(\"data\",[]))}')"

echo "=== 全部完成 ==="
```

---

## 数据库字段映射

### cloud_adoption 表
| 字段 | 类型 | 说明 | API 对应字段 |
|------|------|------|-------------|
| id | bigint | 主键 | id |
| user_id | bigint | 用户ID | userId |
| cat_id | bigint | 猫咪ID | catId |
| adoption_name | varchar(100) | 云养名称 | adoptionName |
| monthly_amount | decimal(10,2) | 每月金额 | monthlyAmount |
| start_date | date | 开始日期 | startDate |
| end_date | date | 结束日期 | endDate |
| is_active | tinyint(1) | 是否进行中 | isActive |
| total_amount | decimal(10,2) | 累计金额 | totalAmount |
| message | text | 寄语 | message |
| create_time | datetime | 创建时间 | createTime |
| update_time | datetime | 更新时间 | updateTime |

### donation 表
| 字段 | 类型 | 说明 | API 对应字段 |
|------|------|------|-------------|
| id | bigint | 主键 | id |
| user_id | bigint | 用户ID | userId |
| cat_id | bigint | 猫咪ID（打赏时使用） | catId |
| crowdfunding_id | bigint | 众筹ID（捐献时使用） | crowdfundingId |
| amount | decimal(10,2) | 金额 | amount |
| message | text | 留言 | message |
| is_anonymous | tinyint(1) | 是否匿名 | isAnonymous |
| payment_method | varchar(50) | 支付方式 | paymentMethod |
| status | varchar(20) | 状态 | status |
| transaction_id | varchar(100) | 交易号 | transactionId |
| create_time | datetime | 创建时间 | createTime |
| update_time | datetime | 更新时间 | updateTime |

> **区分规则**: `crowdfundingId` 有值 → 项目捐献；`catId` 有值且 `crowdfundingId` 为空 → 猫咪打赏。共用 donation 表。

### crowdfunding 表
| 字段 | 类型 | 说明 | API 对应字段 |
|------|------|------|-------------|
| id | bigint | 主键 | id |
| creator_id | bigint | 发起人ID | creatorId |
| title | varchar(200) | 标题 | title |
| description | text | 描述 | description |
| cat_id | bigint | 关联猫咪 | catId |
| target_amount | decimal(10,2) | 目标金额 | targetAmount |
| current_amount | decimal(10,2) | 当前金额 | currentAmount |
| supporter_count | int | 支持人数 | supporterCount |
| start_date | date | 开始日期 | startDate |
| end_date | date | 结束日期 | endDate |
| status | varchar(20) | 状态 | status |
| cover_image | varchar(500) | 封面图 | coverImage |
| category | varchar(50) | 分类 | category |
| contact_info | varchar(200) | 联系方式 | contactInfo |
| create_time | datetime | 创建时间 | createTime |
