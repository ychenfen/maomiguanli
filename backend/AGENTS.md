# Agent instructions (scope: this directory and subdirectories)

## Scope and layout
- This AGENTS.md applies to: `/Users/yuchenxu/Desktop/猫咪领养系统-部署包/deploy/backend/` and below.
- Key files: `cat-rescue.jar`, `application-prod.yml`, `application-override.yml`, `backend.log`.
- Key directories: `logs/`, `static/`, `BOOT-INF/`, `META-INF/`.

## Commands
- Run (Windows): `启动后端.bat`.
- Run (cross-platform): `java -jar cat-rescue.jar --spring.profiles.active=prod`.
- Logs: `backend.log` and `logs/`.

## Configuration
- Primary runtime config is `application-prod.yml` (DB, CORS, static locations, upload path).
- `application-override.yml` exists for static resource overrides; confirm how it is loaded before relying on it.
- Database expects MySQL schema `cat_rescue`; init script and dump live in `../init-db.bat` and `../cat_rescue.sql`.

## Conventions
- Treat `cat-rescue.jar` and `BOOT-INF/` as build artifacts; avoid manual edits.
- If you change backend host/port, update `deploy/frontend/server.js` and `deploy/admin-frontend/js/api.js`.

## Common pitfalls
- Requires Java 17+ and MySQL running on port 3306.
- If static assets do not load, check `spring.web.resources.static-locations` in `application-prod.yml`.

## Do not
- Do not delete or overwrite `cat-rescue.jar` unless replacing it with a rebuilt artifact.
