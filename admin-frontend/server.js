const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = parseInt(process.env.ADMIN_PORT || '5001', 10);
const API_HOST = process.env.API_HOST || '127.0.0.1';
const API_PORT = Number.parseInt(process.env.API_PORT || '8080', 10);

const mimeTypes = {
  '.html': 'text/html',
  '.js': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon'
};

const server = http.createServer((req, res) => {
  let pathname = req.url.split('?')[0];

  // Health check endpoint
  if (pathname === '/api/health' || pathname === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ code: 200, message: 'OK', data: { status: 'UP', service: 'admin-frontend', port: PORT } }));
    return;
  }

  // API 代理
  if (pathname.startsWith('/api/')) {
    const options = {
      hostname: API_HOST,
      port: API_PORT,
      path: req.url,
      method: req.method,
      headers: { ...req.headers, host: `${API_HOST}:${API_PORT}` }
    };

    const proxyReq = http.request(options, (proxyRes) => {
      res.writeHead(proxyRes.statusCode, proxyRes.headers);
      proxyRes.pipe(res);
    });

    proxyReq.on('error', (e) => {
      res.writeHead(502, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ code: 502, message: '后端服务未启动或不可达: ' + e.message, data: null }));
    });

    req.pipe(proxyReq);
    return;
  }

  // Uploads proxy
  if (pathname.startsWith('/uploads/')) {
    const options = {
      hostname: API_HOST,
      port: API_PORT,
      path: req.url,
      method: 'GET',
      headers: { ...req.headers, host: `${API_HOST}:${API_PORT}` }
    };
    const proxyReq2 = http.request(options, (proxyRes) => {
      res.writeHead(proxyRes.statusCode, proxyRes.headers);
      proxyRes.pipe(res);
    });
    proxyReq2.on('error', () => { res.writeHead(404); res.end('Not Found'); });
    proxyReq2.end();
    return;
  }

  // 默认页面
  if (pathname === '/') {
    pathname = '/login.html';
  }

  // 静态文件
  let filePath = path.join(__dirname, pathname);

  // 检查文件是否存在
  fs.readFile(filePath, (err, content) => {
    if (err) {
      if (err.code === 'ENOENT') {
        res.writeHead(404);
        res.end('File not found');
      } else {
        res.writeHead(500);
        res.end('Server error: ' + err.code);
      }
    } else {
      const ext = path.extname(filePath).toLowerCase();
      const contentType = mimeTypes[ext] || 'application/octet-stream';
      res.writeHead(200, { 'Content-Type': contentType });
      res.end(content);
    }
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`管理后台服务运行在 http://localhost:${PORT}`);
  console.log(`登录页面: http://localhost:${PORT}/login.html`);
  console.log(`管理后台: http://localhost:${PORT}/layout.html`);
  console.log(`API 代理: /api/* -> http://${API_HOST}:${API_PORT}/api/*`);
});
