# Agent instructions (scope: this directory and subdirectories)

## Scope and layout
- This AGENTS.md applies to: `/Users/yuchenxu/Desktop/猫咪领养系统-部署包/deploy/frontend/` and below.
- Key files: `index.html`, `server.js`, `api-test.html`.
- Key directories: `assets/` (compiled app), `images/`, `uploads/`.

## Commands
- Run (Windows): `启动前端.bat`.
- Run (cross-platform): `node server.js`.

## API wiring
- `server.js` proxies `/api/*` to the backend defined by `API_HOST`/`API_PORT` (default 127.0.0.1:8080).
- Keep frontend API calls relative to `/api` so the proxy is used.
- If backend host/port changes, update env vars or `server.js`.

## Conventions
- This is a compiled Vue app (no `package.json` here). Prefer updating the original source repo and re-building.
- Avoid editing `assets/*.js` unless doing an emergency hotfix.

## Common pitfalls
- No build tooling is included; running `npm install` here will not help.
- If API calls fail, confirm backend is running and proxy settings in `server.js`.

## Do not
- Do not delete `assets/` unless you are replacing it with a rebuilt bundle.
