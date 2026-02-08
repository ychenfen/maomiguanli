// API Endpoint Definitions
const API_BASE = (window.__API_BASE__ || '/api').replace(/\/$/, '');

const API = {
    // Authentication
    auth: {
        login: `${API_BASE}/users/login`,
        logout: `${API_BASE}/users/logout`,
        currentUser: `${API_BASE}/users/profile`
    },

    // Dashboard
    dashboard: {
        statistics: `${API_BASE}/admin/dashboard/statistics`,
        overview: `${API_BASE}/admin/dashboard/overview`,
        home: `${API_BASE}/admin/dashboard/home`,
        userGrowth: `${API_BASE}/admin/dashboard/user-growth`,
        activityStats: `${API_BASE}/admin/dashboard/activity`,
        popularCats: `${API_BASE}/admin/dashboard/popular-cats`,
        activeUsers: `${API_BASE}/admin/dashboard/active-users`,
        systemHealth: `${API_BASE}/admin/dashboard/system-health`,
        pendingTasks: `${API_BASE}/admin/dashboard/pending-tasks`,
        recentActivities: `${API_BASE}/admin/dashboard/recent-activities`,
        financialOverview: `${API_BASE}/admin/dashboard/financial-overview`,
        adoptionTrends: `${API_BASE}/admin/dashboard/adoption-trends`,
        verificationStats: `${API_BASE}/admin/dashboard/verification-stats`,
        rescueStats: `${API_BASE}/admin/dashboard/rescue-stats`
    },

    // User Management
    users: {
        list: `${API_BASE}/users/page`,
        detail: (id) => `${API_BASE}/users/${id}`,
        create: `${API_BASE}/users/register`,
        update: (id) => `${API_BASE}/users/${id}`,
        delete: (id) => `${API_BASE}/users/${id}`,
        changeStatus: (id) => `${API_BASE}/users/${id}/status`,
        changeRole: (id) => `${API_BASE}/users/${id}/role`,
        statistics: `${API_BASE}/users/statistics`,
        overview: `${API_BASE}/users/overview`
    },

    // Cat Management
    cats: {
        list: `${API_BASE}/cats/page`,
        detail: (id) => `${API_BASE}/cats/${id}`,
        create: `${API_BASE}/cats`,
        update: (id) => `${API_BASE}/cats/${id}`,
        delete: (id) => `${API_BASE}/cats/${id}`,
        updateStatus: (id) => `${API_BASE}/cats/${id}/status`,
        statistics: `${API_BASE}/cats/stats`
    },

    // Adoption Management — 后端路径: /api/adoption-applications
    adoptions: {
        list: `${API_BASE}/adoption-applications/page`,
        detail: (id) => `${API_BASE}/adoption-applications/${id}`,
        approve: (id) => `${API_BASE}/adoption-applications/${id}/review`,
        reject: (id) => `${API_BASE}/adoption-applications/${id}/review`,
        statistics: `${API_BASE}/adoption-applications/statistics`
    },

    // Verification Management — 后端路径: /api/verification
    verifications: {
        list: `${API_BASE}/verification/page`,
        detail: (id) => `${API_BASE}/verification/${id}`,
        approve: (id) => `${API_BASE}/verification/review`,
        reject: (id) => `${API_BASE}/verification/review`,
        batchApprove: `${API_BASE}/verification/enhanced/batch-review`,
        statistics: `${API_BASE}/verification/enhanced/statistics`
    },

    // Rescue Management — 后端路径: /api/rescue-info
    rescues: {
        list: `${API_BASE}/rescue-info/page`,
        detail: (id) => `${API_BASE}/rescue-info/${id}`,
        create: `${API_BASE}/rescue-info`,
        update: (id) => `${API_BASE}/rescue-info/${id}`,
        delete: (id) => `${API_BASE}/rescue-info/${id}`,
        updateStatus: (id) => `${API_BASE}/rescue-info/${id}/close`,
        assign: (id) => `${API_BASE}/rescue-info/${id}/respond`,
        statistics: `${API_BASE}/rescue-info/statistics`
    },

    // Finance Management — 后端路径: /api/finance
    finance: {
        list: `${API_BASE}/finance/page`,
        detail: (id) => `${API_BASE}/finance/${id}`,
        approve: (id) => `${API_BASE}/finance/${id}/approve`,
        reject: (id) => `${API_BASE}/finance/${id}/approve`,
        statistics: `${API_BASE}/finance/stats`,
        report: `${API_BASE}/finance/export`,
        export: `${API_BASE}/finance/export`
    },

    // Cat Tag Management — 后端路径: /api/cat-tags (无 /page，GET 根路径返回全部)
    catTags: {
        list: `${API_BASE}/cat-tags`,
        listByType: (type) => `${API_BASE}/cat-tags/type/${type}`,
        detail: (id) => `${API_BASE}/cat-tags/${id}`,
        create: `${API_BASE}/cat-tags`,
        update: (id) => `${API_BASE}/cat-tags/${id}`,
        delete: (id) => `${API_BASE}/cat-tags/${id}`
    },

    // University Management — 后端路径: /api/university (单数)
    universities: {
        list: `${API_BASE}/university/page`,
        detail: (id) => `${API_BASE}/university/${id}`,
        create: `${API_BASE}/university`,
        update: (id) => `${API_BASE}/university/${id}`,
        delete: (id) => `${API_BASE}/university/${id}`
    },

    // Dynamic/Community Management
    dynamics: {
        list: `${API_BASE}/dynamics/page`,
        detail: (id) => `${API_BASE}/dynamics/${id}`,
        delete: (id) => `${API_BASE}/dynamics/${id}`,
        statistics: `${API_BASE}/dynamics/statistics`
    },

    // Crowdfunding Management — approve→activate, reject→cancel
    crowdfunding: {
        list: `${API_BASE}/crowdfunding/page`,
        detail: (id) => `${API_BASE}/crowdfunding/${id}`,
        approve: (id) => `${API_BASE}/crowdfunding/${id}/activate`,
        reject: (id) => `${API_BASE}/crowdfunding/${id}/cancel`,
        close: (id) => `${API_BASE}/crowdfunding/${id}/cancel`,
        statistics: `${API_BASE}/crowdfunding/stats/creator`
    },

    // Notification Management — send-batch→batch-send
    notifications: {
        list: `${API_BASE}/notifications/page`,
        detail: (id) => `${API_BASE}/notifications/${id}`,
        send: `${API_BASE}/notifications/send`,
        sendBatch: `${API_BASE}/notifications/batch-send`,
        delete: (id) => `${API_BASE}/notifications/${id}`,
        statistics: `${API_BASE}/notifications/statistics`
    },

    // Cloud Adoption Management
    cloudAdoption: {
        list: `${API_BASE}/cloud-adoption/page`,
        detail: (id) => `${API_BASE}/cloud-adoption/${id}`,
        myAdoptions: `${API_BASE}/cloud-adoption/my-adoptions`,
        create: `${API_BASE}/cloud-adoption`,
        update: (id) => `${API_BASE}/cloud-adoption/${id}`,
        cancel: (id) => `${API_BASE}/cloud-adoption/${id}/cancel`,
        renew: (id) => `${API_BASE}/cloud-adoption/${id}/renew`,
        stats: `${API_BASE}/cloud-adoption/stats`
    },

    // Donation Management
    donation: {
        list: `${API_BASE}/donation/page`,
        detail: (id) => `${API_BASE}/donation/${id}`,
        myDonations: `${API_BASE}/donation/my-donations`,
        create: `${API_BASE}/donation`,
        catDonations: (catId) => `${API_BASE}/donation/cat/${catId}`,
        crowdfundingDonations: (cfId) => `${API_BASE}/donation/crowdfunding/${cfId}`,
        totalByCat: (catId) => `${API_BASE}/donation/total/cat/${catId}`,
        totalByCrowdfunding: (cfId) => `${API_BASE}/donation/total/crowdfunding/${cfId}`,
        userStats: `${API_BASE}/donation/stats/user`
    },

    // Health check
    health: `${API_BASE}/health`
};

// Make API_ENDPOINTS globally accessible
window.API_ENDPOINTS = API;
