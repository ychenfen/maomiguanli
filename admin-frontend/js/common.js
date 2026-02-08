// Common Utilities - Auth, API Client, Routing, Notifications

// ==================== Authentication ====================
const Auth = {
    // Check if user is authenticated
    isAuthenticated() {
        const token = localStorage.getItem('admin_token');
        const user = localStorage.getItem('admin_user');
        return !!(token && user);
    },

    // Get current token
    getToken() {
        return localStorage.getItem('admin_token');
    },

    // Get current user
    getUser() {
        const user = localStorage.getItem('admin_user');
        return user ? JSON.parse(user) : null;
    },

    // Set authentication data
    setAuth(token, user) {
        localStorage.setItem('admin_token', token);
        localStorage.setItem('admin_user', JSON.stringify(user));
    },

    // Clear authentication data
    clearAuth() {
        localStorage.removeItem('admin_token');
        localStorage.removeItem('admin_user');
    },

    // Check if user has permission
    hasPermission(permission) {
        const user = this.getUser();
        if (!user) return false;

        // SUPER_ADMIN has all permissions
        if (user.role === 'SUPER_ADMIN') return true;

        // ADMIN has most permissions except role management
        if (user.role === 'ADMIN') {
            const restrictedPermissions = ['CHANGE_USER_ROLE', 'DELETE_ADMIN'];
            return !restrictedPermissions.includes(permission);
        }

        return false;
    },

    // Redirect to login if not authenticated
    requireAuth() {
        if (!this.isAuthenticated()) {
            window.location.href = 'login.html';
            return false;
        }
        return true;
    },

    // Logout
    logout() {
        this.clearAuth();
        window.location.href = 'login.html';
    }
};

// ==================== API Client ====================
const ApiClient = {
    // Make API request
    async request(url, options = {}) {
        const token = Auth.getToken();

        // Handle params for GET requests
        if (options.params) {
            // Map frontend param names to backend param names
            const params = { ...options.params };
            if (params.page !== undefined) {
                params.pageNum = params.page;
                delete params.page;
            }
            if (params.size !== undefined) {
                params.pageSize = params.size;
                delete params.size;
            }

            const queryString = new URLSearchParams(params).toString();
            url = queryString ? `${url}?${queryString}` : url;
            delete options.params;
        }

        // Handle body for POST/PUT requests
        if (options.body && typeof options.body === 'object') {
            options.body = JSON.stringify(options.body);
        }

        const defaultOptions = {
            headers: {
                'Content-Type': 'application/json',
                ...(token && { 'Authorization': `Bearer ${token}` })
            }
        };

        const finalOptions = {
            ...defaultOptions,
            ...options,
            headers: {
                ...defaultOptions.headers,
                ...options.headers
            }
        };

        try {
            console.log('API Request:', url, finalOptions);
            const response = await fetch(url, finalOptions);
            console.log('API Response Status:', response.status);

            // Check HTTP status code first
            if (response.status === 401) {
                Toast.error('登录已过期，请重新登录');
                setTimeout(() => Auth.logout(), 2000);
                throw new Error('Unauthorized');
            }

            const result = await response.json();
            console.log('API Response Body:', result);

            // Also check response body code
            if (result.code === 401) {
                Toast.error('登录已过期，请重新登录');
                setTimeout(() => Auth.logout(), 2000);
                throw new Error('Unauthorized');
            }

            // Check for error codes (backend might use 0 for success or 200)
            if (result.code && result.code !== 200 && result.code !== 0) {
                throw new Error(result.message || result.msg || 'Request failed');
            }

            // Return data if available, otherwise return full result
            return result.data !== undefined ? result.data : result;
        } catch (error) {
            console.error('API request error:', error);
            throw error;
        }
    },

    // GET request
    async get(url, params = {}) {
        const queryString = new URLSearchParams(params).toString();
        const fullUrl = queryString ? `${url}?${queryString}` : url;
        return this.request(fullUrl, { method: 'GET' });
    },

    // POST request
    async post(url, data = {}) {
        return this.request(url, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    // PUT request
    async put(url, data = {}) {
        return this.request(url, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },

    // DELETE request
    async delete(url) {
        return this.request(url, { method: 'DELETE' });
    }
};

// ==================== Router ====================
const Router = {
    routes: {},
    currentRoute: null,

    // Register a route
    register(path, handler) {
        this.routes[path] = handler;
    },

    // Navigate to a route
    navigate(path) {
        window.location.hash = path;
    },

    // Get current route
    getCurrentRoute() {
        return window.location.hash.slice(1) || '/';
    },

    // Initialize router
    init() {
        // Handle hash change
        window.addEventListener('hashchange', () => {
            this.handleRoute();
        });

        // Handle initial route
        this.handleRoute();
    },

    // Handle route change
    handleRoute() {
        const path = this.getCurrentRoute();
        this.currentRoute = path;

        // Find matching route
        const handler = this.routes[path];
        if (handler) {
            handler();
        } else {
            // Default route
            if (this.routes['/']) {
                this.routes['/']();
            }
        }

        // Update active nav item
        this.updateActiveNav(path);
    },

    // Update active navigation item
    updateActiveNav(path) {
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.remove('active');
            if (item.getAttribute('href') === `#${path}`) {
                item.classList.add('active');
            }
        });
    }
};

// ==================== Toast Notifications ====================
const Toast = {
    container: null,

    // Initialize toast container
    init() {
        if (!this.container) {
            this.container = document.createElement('div');
            this.container.className = 'toast-container';
            document.body.appendChild(this.container);
        }
    },

    // Show toast
    show(type, title, message, duration = 3000) {
        this.init();

        const toast = document.createElement('div');
        toast.className = `toast ${type}`;

        const icons = {
            success: '✓',
            error: '✕',
            warning: '⚠',
            info: 'ℹ'
        };

        toast.innerHTML = `
            <div class="toast-icon">${icons[type] || 'ℹ'}</div>
            <div class="toast-content">
                <div class="toast-title">${title}</div>
                ${message ? `<div class="toast-message">${message}</div>` : ''}
            </div>
            <button class="toast-close" onclick="this.parentElement.remove()">×</button>
        `;

        this.container.appendChild(toast);

        // Auto remove after duration
        if (duration > 0) {
            setTimeout(() => {
                toast.style.animation = 'slideOutRight 0.3s ease';
                setTimeout(() => toast.remove(), 300);
            }, duration);
        }
    },

    success(title, message, duration) {
        this.show('success', title, message, duration);
    },

    error(title, message, duration) {
        this.show('error', title, message, duration);
    },

    warning(title, message, duration) {
        this.show('warning', title, message, duration);
    },

    info(title, message, duration) {
        this.show('info', title, message, duration);
    }
};

// Add slideOutRight animation
const style = document.createElement('style');
style.textContent = `
    @keyframes slideOutRight {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(100%);
        }
    }
`;
document.head.appendChild(style);

// ==================== Loading Overlay ====================
const Loading = {
    overlay: null,

    // Show loading overlay
    show(message = '加载中...') {
        if (!this.overlay) {
            this.overlay = document.createElement('div');
            this.overlay.className = 'loading-overlay';
            this.overlay.innerHTML = `
                <div class="loading-content">
                    <div class="loading-spinner"></div>
                    <div class="loading-message">${message}</div>
                </div>
            `;
            document.body.appendChild(this.overlay);
        }
        this.overlay.style.display = 'flex';
    },

    // Hide loading overlay
    hide() {
        if (this.overlay) {
            this.overlay.style.display = 'none';
        }
    }
};

// ==================== Modal ====================
const Modal = {
    // Show modal
    show(options) {
        const {
            title = '提示',
            content = '',
            onConfirm = null,
            onCancel = null,
            confirmText = '确定',
            cancelText = '取消',
            showCancel = true
        } = options;

        const overlay = document.createElement('div');
        overlay.className = 'modal-overlay';

        overlay.innerHTML = `
            <div class="modal">
                <div class="modal-header">
                    <div class="modal-title">${title}</div>
                    <button class="modal-close">×</button>
                </div>
                <div class="modal-body">
                    ${content}
                </div>
                <div class="modal-footer">
                    ${showCancel ? `<button class="btn btn-default modal-cancel">${cancelText}</button>` : ''}
                    <button class="btn btn-primary modal-confirm">${confirmText}</button>
                </div>
            </div>
        `;

        document.body.appendChild(overlay);

        // Close modal
        const closeModal = () => {
            overlay.style.animation = 'fadeOut 0.15s ease';
            setTimeout(() => overlay.remove(), 150);
        };

        // Handle close button
        overlay.querySelector('.modal-close').addEventListener('click', () => {
            if (onCancel) onCancel();
            closeModal();
        });

        // Handle cancel button
        if (showCancel) {
            overlay.querySelector('.modal-cancel').addEventListener('click', () => {
                if (onCancel) onCancel();
                closeModal();
            });
        }

        // Handle confirm button
        overlay.querySelector('.modal-confirm').addEventListener('click', () => {
            if (onConfirm) onConfirm();
            closeModal();
        });

        // Handle overlay click
        overlay.addEventListener('click', (e) => {
            if (e.target === overlay) {
                if (onCancel) onCancel();
                closeModal();
            }
        });
    },

    // Show confirm dialog
    confirm(title, content, onConfirm, onCancel) {
        this.show({
            title,
            content,
            onConfirm,
            onCancel,
            showCancel: true
        });
    },

    // Show alert dialog
    alert(title, content, onConfirm) {
        this.show({
            title,
            content,
            onConfirm,
            showCancel: false
        });
    }
};

// Add fadeOut animation
const fadeOutStyle = document.createElement('style');
fadeOutStyle.textContent = `
    @keyframes fadeOut {
        from { opacity: 1; }
        to { opacity: 0; }
    }
`;
document.head.appendChild(fadeOutStyle);

// ==================== Utility Functions ====================
const Utils = {
    // Format date
    formatDate(date, format = 'YYYY-MM-DD HH:mm:ss') {
        if (!date) return '-';
        const d = new Date(date);
        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        const hours = String(d.getHours()).padStart(2, '0');
        const minutes = String(d.getMinutes()).padStart(2, '0');
        const seconds = String(d.getSeconds()).padStart(2, '0');

        return format
            .replace('YYYY', year)
            .replace('MM', month)
            .replace('DD', day)
            .replace('HH', hours)
            .replace('mm', minutes)
            .replace('ss', seconds);
    },

    // Format currency
    formatCurrency(amount) {
        if (amount === null || amount === undefined) return '¥0.00';
        return `¥${Number(amount).toFixed(2)}`;
    },

    // Debounce function
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    // Get query parameter
    getQueryParam(name) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(name);
    },

    // Copy to clipboard
    async copyToClipboard(text) {
        try {
            await navigator.clipboard.writeText(text);
            Toast.success('复制成功', '内容已复制到剪贴板');
        } catch (error) {
            Toast.error('复制失败', '请手动复制');
        }
    }
};
