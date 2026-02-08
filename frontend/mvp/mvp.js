(() => {
  const API_BASE = (window.__API_BASE__ || '/api').replace(/\/$/, '');

  const qs = (name) => new URLSearchParams(window.location.search).get(name);

  const getToken = () => localStorage.getItem('user_token') || '';
  const setToken = (token) => { if (token) localStorage.setItem('user_token', token); };
  const getUser = () => { try { return JSON.parse(localStorage.getItem('user_info') || '{}'); } catch { return {}; } };
  const setUser = (u) => localStorage.setItem('user_info', JSON.stringify(u));
  const isLoggedIn = () => !!getToken();

  const authHeaders = () => {
    const token = getToken();
    return token ? { Authorization: `Bearer ${token}` } : {};
  };

  const apiGet = async (path, params) => {
    const url = new URL(`${API_BASE}${path}`, window.location.origin);
    if (params) {
      Object.entries(params).forEach(([k, v]) => {
        if (v !== undefined && v !== null && v !== '') url.searchParams.append(k, v);
      });
    }
    const res = await fetch(url.toString(), { headers: { ...authHeaders() } });
    return res.json();
  };

  const apiSend = async (method, path, body) => {
    const res = await fetch(`${API_BASE}${path}`, {
      method,
      headers: { 'Content-Type': 'application/json', ...authHeaders() },
      body: body ? JSON.stringify(body) : undefined
    });
    return res.json();
  };

  // Toast notification
  const toast = (msg, type = 'info') => {
    const el = document.createElement('div');
    el.className = `toast toast-${type}`;
    el.textContent = msg;
    document.body.appendChild(el);
    setTimeout(() => el.remove(), 3000);
  };

  // Format date
  const fmtDate = (d) => {
    if (!d) return '-';
    return d.replace('T', ' ').substring(0, 16);
  };

  // Format currency
  const fmtMoney = (v) => {
    if (v === null || v === undefined) return '0.00';
    return Number(v).toFixed(2);
  };

  // Default cat image
  const catImg = (url) => url || '/uploads/cats/default.jpg';

  // Require login
  const requireLogin = () => {
    if (!isLoggedIn()) {
      toast('请先登录', 'error');
      setTimeout(() => { window.location.href = '/mvp/mvp-login.html?redirect=' + encodeURIComponent(window.location.href); }, 500);
      return false;
    }
    return true;
  };

  // Render top nav
  const renderNav = (active) => {
    const user = getUser();
    const logged = isLoggedIn();
    return `
    <div class="top-nav">
      <span class="logo">🐱 校园猫咪救助</span>
      <nav>
        <a href="/mvp/cloud-adoption-list.html" class="${active==='cloud-list'?'active':''}">云养猫咪</a>
        <a href="/mvp/cloud-adoption-order.html" class="${active==='cloud-order'?'active':''}">发起云养</a>
        <a href="/mvp/cloud-adoption-mine.html" class="${active==='cloud-mine'?'active':''}">我的云养</a>
        <a href="/mvp/donation-projects.html" class="${active==='donate-list'?'active':''}">捐献项目</a>
        <a href="/mvp/donation-mine.html" class="${active==='donate-mine'?'active':''}">我的捐献</a>
        <a href="/mvp/tip.html" class="${active==='tip'?'active':''}">打赏猫咪</a>
      </nav>
      <div class="user-info">
        ${logged
          ? `<span class="avatar">${(user.username||'U')[0].toUpperCase()}</span>
             <span>${user.username||'用户'}</span>
             <a href="#" onclick="MVP.logout();return false" style="color:rgba(255,255,255,.8);font-size:13px;margin-left:6px;">退出</a>`
          : `<a href="/mvp/mvp-login.html" style="color:#fff;text-decoration:none;">登录</a>`
        }
      </div>
    </div>`;
  };

  const logout = () => {
    localStorage.removeItem('user_token');
    localStorage.removeItem('user_info');
    window.location.href = '/mvp/mvp-login.html';
  };

  // Pagination renderer
  const renderPagination = (current, total, onChange) => {
    const wrap = document.createElement('div');
    wrap.className = 'pagination';
    const prev = document.createElement('button');
    prev.textContent = '上一页';
    prev.disabled = current <= 1;
    prev.onclick = () => onChange(current - 1);
    wrap.appendChild(prev);

    const maxShow = 5;
    let start = Math.max(1, current - 2);
    let end = Math.min(total, start + maxShow - 1);
    if (end - start < maxShow - 1) start = Math.max(1, end - maxShow + 1);

    for (let i = start; i <= end; i++) {
      const b = document.createElement('button');
      b.textContent = i;
      if (i === current) b.className = 'active';
      b.onclick = () => onChange(i);
      wrap.appendChild(b);
    }

    const next = document.createElement('button');
    next.textContent = '下一页';
    next.disabled = current >= total;
    next.onclick = () => onChange(current + 1);
    wrap.appendChild(next);
    return wrap;
  };

  window.MVP = {
    API_BASE, qs, getToken, setToken, getUser, setUser, isLoggedIn, requireLogin,
    apiGet, apiPost: (p, b) => apiSend('POST', p, b), apiPut: (p, b) => apiSend('PUT', p, b),
    toast, fmtDate, fmtMoney, catImg, renderNav, renderPagination, logout
  };
})();
