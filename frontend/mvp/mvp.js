(() => {
  const API_BASE = (window.__API_BASE__ || '/api').replace(/\/$/, '');

  const qs = (name) => new URLSearchParams(window.location.search).get(name);

  const getToken = () => localStorage.getItem('user_token') || '';
  const setToken = (token) => {
    if (token) {
      localStorage.setItem('user_token', token);
    }
  };

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
      headers: {
        'Content-Type': 'application/json',
        ...authHeaders()
      },
      body: body ? JSON.stringify(body) : undefined
    });
    return res.json();
  };

  window.MVP = {
    API_BASE,
    qs,
    getToken,
    setToken,
    apiGet,
    apiPost: (path, body) => apiSend('POST', path, body),
    apiPut: (path, body) => apiSend('PUT', path, body)
  };
})();
