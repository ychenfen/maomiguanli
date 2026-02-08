#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

APP_PORT="${APP_PORT:-8080}"
API_HOST="${API_HOST:-127.0.0.1}"
API_PORT="${API_PORT:-8080}"

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-cat_rescue}"
DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASS:-123456}"

CORS_ALLOWED_ORIGINS="${CORS_ALLOWED_ORIGINS:-http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:5000,http://localhost:5001}"
SPRING_PROFILES_ACTIVE="${SPRING_PROFILES_ACTIVE:-local}"

log() {
  printf "[%s] %s\n" "$(date +%H:%M:%S)" "$*"
}

log "检查 Java..."
if ! java -version >/dev/null 2>&1; then
  echo "未检测到 Java，请先安装 Java 17+" >&2
  exit 1
fi
java -version 2>&1 | head -n 1

log "检查 Node.js..."
if ! node -v >/dev/null 2>&1; then
  echo "未检测到 Node.js，请先安装 Node 16+" >&2
  exit 1
fi
node -v

log "检查 MySQL 连接..."
MYSQL_OK=0
if command -v mysqladmin >/dev/null 2>&1; then
  if [ -n "$DB_PASS" ]; then
    mysqladmin ping -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" >/dev/null 2>&1 && MYSQL_OK=1 || MYSQL_OK=0
  else
    mysqladmin ping -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" >/dev/null 2>&1 && MYSQL_OK=1 || MYSQL_OK=0
  fi
elif command -v nc >/dev/null 2>&1; then
  nc -z "$DB_HOST" "$DB_PORT" >/dev/null 2>&1 && MYSQL_OK=1 || MYSQL_OK=0
fi

if [ "$MYSQL_OK" -ne 1 ]; then
  log "MySQL 未就绪：请确认 MySQL 已启动，并执行 init-db.bat 初始化数据库。"
else
  log "MySQL 端口可达。"
fi

if command -v mysql >/dev/null 2>&1; then
  DB_EXISTS=""
  if [ -n "$DB_PASS" ]; then
    DB_EXISTS=$(mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" -N -s -e "SHOW DATABASES LIKE '$DB_NAME';" 2>/dev/null || true)
  else
    DB_EXISTS=$(mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -N -s -e "SHOW DATABASES LIKE '$DB_NAME';" 2>/dev/null || true)
  fi
  if [ -z "$DB_EXISTS" ]; then
    log "数据库 $DB_NAME 不存在：请先运行初始化脚本。"
  fi
fi

log "启动后端 (端口 $APP_PORT)..."
nohup env \
  APP_PORT="$APP_PORT" \
  DB_HOST="$DB_HOST" DB_PORT="$DB_PORT" DB_NAME="$DB_NAME" DB_USER="$DB_USER" DB_PASS="$DB_PASS" \
  CORS_ALLOWED_ORIGINS="$CORS_ALLOWED_ORIGINS" \
  java -jar backend/cat-rescue.jar --spring.profiles.active="$SPRING_PROFILES_ACTIVE" \
  > backend/backend.log 2>&1 &
BACK_PID=$!
log "后端 PID: $BACK_PID (日志: backend/backend.log)"

log "启动用户前端 (端口 5000)..."
nohup env API_HOST="$API_HOST" API_PORT="$API_PORT" node frontend/server.js > frontend/frontend.log 2>&1 &
FRONT_PID=$!
log "用户前端 PID: $FRONT_PID (日志: frontend/frontend.log)"

log "启动管理后台 (端口 5001)..."
nohup env API_HOST="$API_HOST" API_PORT="$API_PORT" node admin-frontend/server.js > admin-frontend/admin.log 2>&1 &
ADMIN_PID=$!
log "管理后台 PID: $ADMIN_PID (日志: admin-frontend/admin.log)"

sleep 6

log "健康检查..."
health_url="http://127.0.0.1:${APP_PORT}/actuator/health"
health_status=$(curl -sS -o /dev/null -w "%{http_code}" "$health_url" || echo "000")
if [ "$health_status" != "200" ]; then
  alt_url="http://127.0.0.1:${APP_PORT}/api/health"
  alt_status=$(curl -sS -o /dev/null -w "%{http_code}" "$alt_url" || echo "000")
else
  alt_url=""
  alt_status=""
fi

frontend_status=$(curl -sS -o /dev/null -w "%{http_code}" "http://127.0.0.1:5000/" || echo "000")
admin_status=$(curl -sS -o /dev/null -w "%{http_code}" "http://127.0.0.1:5001/" || echo "000")

log "后端健康检查: ${health_url} -> ${health_status}"
if [ -n "$alt_url" ]; then
  log "后端备用检查: ${alt_url} -> ${alt_status}"
fi
log "用户前端: http://127.0.0.1:5000/ -> ${frontend_status}"
log "管理后台: http://127.0.0.1:5001/ -> ${admin_status}"

log "启动完成。"
