const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = parseInt(process.env.USER_PORT || '5000', 10);
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
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf'
};

const server = http.createServer((req, res) => {
  let pathname = req.url.split('?')[0];

  // Health check
  if (pathname === '/api/health' || pathname === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ code: 200, message: 'OK', data: { status: 'UP', service: 'user-frontend', port: PORT } }));
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
      res.end(JSON.stringify({ code: 502, message: '后端服务未启动: ' + e.message, data: null }));
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

  // 静态文件
  let filePath = path.join(__dirname, pathname);

  // 检查文件是否存在
  try {
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) {
      filePath = path.join(filePath, 'index.html');
    }
  } catch (e) {
    // 文件不存在，返回 index.html（SPA 支持）
    filePath = path.join(__dirname, 'index.html');
  }

  const ext = path.extname(filePath).toLowerCase();
  const contentType = mimeTypes[ext] || 'application/octet-stream';

  fs.readFile(filePath, (err, content) => {
    if (err) {
      // 文件不存在，返回 index.html
      fs.readFile(path.join(__dirname, 'index.html'), (err2, content2) => {
        if (err2) {
          res.writeHead(404);
          res.end('Not Found');
        } else {
          res.writeHead(200, { 'Content-Type': 'text/html' });
          res.end(content2);
        }
      });
    } else {
      res.writeHead(200, { 'Content-Type': contentType });
      res.end(content);
    }
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`用户端服务运行在 http://localhost:${PORT}`);
  console.log(`API 代理: /api/* -> http://${API_HOST}:${API_PORT}/api/*`);
});
