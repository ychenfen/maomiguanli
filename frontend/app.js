const API_BASE = (window.__API_BASE__ || '/api').replace(/\/$/, '');
const DEFAULT_ADMIN_PORT = window.location.port === '15500' ? '15501' : '5001';
const ADMIN_BASE = (window.__ADMIN_BASE__ || `${window.location.protocol}//${window.location.hostname}:${DEFAULT_ADMIN_PORT}`).replace(/\/$/, '');

const STORAGE_KEYS = {
  token: 'cat_rescue_token',
  user: 'cat_rescue_user',
  favorites: 'animal_rescue_favorites',
  history: 'animal_rescue_history',
  materials: 'animal_rescue_material_appointments'
};

const state = {
  token: readToken(),
  user: readJSON(STORAGE_KEYS.user, null),
  verified: false,
  verificationStatus: 'UNSUBMITTED',
  verificationRecord: null,
  authModalOpen: false,
  authMode: 'login',
  authForm: {
    username: 'zhangsan',
    password: '123456',
    realName: '',
    phone: '',
    email: ''
  },
  cats: [],
  catStats: null,
  universities: [],
  hotCats: [],
  latestCats: [],
  archiveFilters: {
    keyword: '',
    status: '',
    gender: ''
  },
  selectedAnimalId: null,
  favorites: readJSON(STORAGE_KEYS.favorites, []),
  history: readJSON(STORAGE_KEYS.history, []),
  adoptionForm: {
    reason: '',
    livingCondition: '',
    experience: '',
    contactPhone: '',
    contactAddress: ''
  },
  rescueLocked: true,
  rescues: [],
  rescueForm: {
    title: '',
    topic: 'INJURED',
    description: '',
    location: '',
    contactPhone: '',
    priority: 1,
    imagePath: '',
    needsVet: true
  },
  rescueBusyId: null,
  dynamics: [],
  communityFilter: 'all',
  comments: {},
  commentDrafts: {},
  dynamicForm: {
    content: '',
    type: 'UPDATE',
    location: '',
    imagePath: ''
  },
  crowdfunding: [],
  hotCrowdfunding: [],
  financeRecords: [],
  donationForm: {
    crowdfundingId: '',
    amount: 5,
    message: '',
    isAnonymous: false,
    paymentMethod: 'WECHAT'
  },
  donations: [],
  materialForm: {
    contactName: '',
    contactPhone: '',
    itemType: 'CAT_FOOD',
    quantity: '',
    pickupPoint: '公益社团办公室',
    note: ''
  },
  materialAppointments: readJSON(STORAGE_KEYS.materials, []),
  applications: [],
  profileForm: {
    username: '',
    realName: '',
    studentId: '',
    phone: '',
    email: '',
    gender: '',
    college: '',
    introduction: ''
  },
  verificationForm: {
    universityId: '1',
    realName: '',
    studentId: '',
    department: '',
    idCard: '',
    verificationType: 'STUDENT',
    idCardFront: '',
    idCardBack: '',
    studentCard: ''
  },
  uploadingField: '',
  verificationRequired: false,
  loading: false,
  booted: false
};

const memorialStory = {
  title: '讣告纪念: 丑橘',
  image: '/images/memorial/chuju.jpg',
  summary:
    '愿每一只曾在校园里被温柔对待过的小生命，都被记住。纪念丑橘，也提醒我们把救助、绝育、医疗和领养这条路继续走下去。'
};

const DEFAULT_UNIVERSITIES = [
  { id: 1, name: '示范大学', city: '北京市' }
];

const CAMPUS_POINTS = [
  { label: '图书馆后面草坪', x: '18%', y: '26%' },
  { label: '第二食堂门口', x: '68%', y: '24%' },
  { label: '7号宿舍楼绿化带', x: '30%', y: '68%' },
  { label: '公益社团办公室', x: '72%', y: '64%' },
  { label: '宠物友好门诊点', x: '54%', y: '46%' }
];

const app = document.getElementById('app');

document.addEventListener('DOMContentLoaded', bootstrap);
document.addEventListener('click', handleClick);
document.addEventListener('submit', handleSubmit);
document.addEventListener('input', handleInput);
document.addEventListener('change', handleChange);
document.addEventListener('keydown', (event) => {
  if (event.key === 'Escape' && state.authModalOpen) {
    state.authModalOpen = false;
    render();
  }
});

async function bootstrap() {
  await loadPublicData();
  if (state.token) {
    await loadUserData();
  }
  state.booted = true;
  render();
}

async function loadPublicData() {
  state.loading = true;
  const tasks = await Promise.allSettled([
    api('/cats/stats', { auth: false }),
    api('/cats/page', { auth: false, query: { page: 1, current: 1, size: 36 } }),
    api('/cats/hot', { auth: false, query: { limit: 3 } }),
    api('/cats/latest', { auth: false, query: { limit: 3 } }),
    api('/dynamics/page', { auth: false, query: { current: 1, size: 12 } }),
    api('/crowdfunding/page', { auth: false, query: { current: 1, size: 12 } }),
    api('/crowdfunding/hot', { auth: false, query: { limit: 3 } }),
    api('/finance/public', { auth: false }),
    api('/university/page', { auth: false, query: { page: 1, size: 50 } })
  ]);

  state.catStats = unwrapSettled(tasks[0], null);
  state.cats = pageRecords(unwrapSettled(tasks[1], []));
  state.hotCats = unwrapSettled(tasks[2], []);
  state.latestCats = unwrapSettled(tasks[3], []);
  state.dynamics = pageRecords(unwrapSettled(tasks[4], []));
  state.crowdfunding = pageRecords(unwrapSettled(tasks[5], []));
  state.hotCrowdfunding = unwrapSettled(tasks[6], []);
  state.financeRecords = unwrapSettled(tasks[7], []);
  state.universities = pageRecords(unwrapSettled(tasks[8], DEFAULT_UNIVERSITIES)) || DEFAULT_UNIVERSITIES;

  if (!state.selectedAnimalId) {
    const firstAdoptable = state.cats.find((item) => item.status === 'ADOPTABLE') || state.cats[0];
    state.selectedAnimalId = firstAdoptable ? firstAdoptable.id : null;
  }

  if (!state.donationForm.crowdfundingId && state.crowdfunding[0]) {
    state.donationForm.crowdfundingId = String(state.crowdfunding[0].id);
  }

  if (!state.verificationForm.universityId && state.universities[0]) {
    state.verificationForm.universityId = String(state.universities[0].id);
  }

  state.loading = false;
}

async function loadUserData() {
  try {
    const tasks = await Promise.allSettled([
      api('/users/profile'),
      api('/verification/check-verified'),
      api('/verification/status'),
      api('/verification/my-verification'),
      api('/adoption-applications/my-applications', { query: { page: 1, pageSize: 8 } }),
      api('/donation/my-donations', { query: { page: 1, pageSize: 8 } }),
      api('/rescue-info/page', { query: { pageNum: 1, pageSize: 20 } })
    ]);

    const profile = unwrapSettled(tasks[0], null);
    if (!profile) {
      throw new Error('用户信息加载失败');
    }

    const verified = unwrapSettled(tasks[1], false);
    const verificationStatus = unwrapSettled(tasks[2], 'UNSUBMITTED');
    const verificationRecord = unwrapSettled(tasks[3], null);
    const applications = unwrapSettled(tasks[4], []);
    const donations = unwrapSettled(tasks[5], []);
    const rescues = unwrapSettled(tasks[6], []);

    state.user = profile;
    writeJSON(STORAGE_KEYS.user, profile);
    state.verified = Boolean(verified);
    state.verificationStatus = String(verificationStatus || 'UNSUBMITTED');
    state.verificationRecord = verificationRecord || null;
    state.applications = Array.isArray(applications) ? applications : pageRecords(applications);
    state.donations = filterTimestampedRecords(Array.isArray(donations) ? donations : pageRecords(donations));
    state.rescues = filterTimestampedRecords(pageRecords(rescues));
    state.rescueLocked = false;
    Object.assign(state.profileForm, {
      username: profile.username || '',
      realName: profile.realName || '',
      studentId: profile.studentId || '',
      phone: profile.phone || '',
      email: profile.email || '',
      gender: profile.gender ?? '',
      college: profile.college || '',
      introduction: profile.introduction || ''
    });
    syncVerificationForm(profile, verificationRecord);

    if (!state.adoptionForm.contactPhone) {
      state.adoptionForm.contactPhone = profile.phone || '';
    }

    if (!state.rescueForm.contactPhone) {
      state.rescueForm.contactPhone = profile.phone || '';
    }
  } catch (error) {
    clearAuth();
    showToast(error.message || '登录状态已失效，请重新登录', 'warning');
  }
}

function render() {
  app.innerHTML = `
    <div class="app-shell">
      ${renderHeader()}
      ${renderHero()}
      <main class="page-main">
        ${renderArchiveSection()}
        ${renderAdoptionSection()}
        ${renderRescueSection()}
        ${renderDonationSection()}
        ${renderCommunitySection()}
        ${renderProfileSection()}
      </main>
      ${renderAuthModal()}
      <div class="toast-host" id="toast-host"></div>
    </div>
  `;
  flushToasts();
}

function renderHeader() {
  return `
    <header class="site-header">
      <div class="brand-block">
        <span class="brand-kicker">Campus Rescue Ledger</span>
        <a href="#hero" class="brand-mark" data-scroll="hero">
          <span class="brand-paw">✦</span>
          <span>
            <strong>校园流浪动物救助系统</strong>
            <small>领养 · 救助 · 社区 · 为爱发电</small>
          </span>
        </a>
      </div>
      <nav class="site-nav">
        <button class="nav-link" data-scroll="archive">动物档案</button>
        <button class="nav-link" data-scroll="adoption">在线领养</button>
        <button class="nav-link" data-scroll="rescue">救助中心</button>
        <button class="nav-link" data-scroll="donate">为爱发电</button>
        <button class="nav-link" data-scroll="community">社区动态</button>
        <button class="nav-link" data-scroll="profile">个人中心</button>
      </nav>
      <div class="header-actions">
        <a class="admin-link" href="${escapeAttr(`${ADMIN_BASE}/login.html`)}" target="_blank" rel="noreferrer">管理后台</a>
        ${state.user ? `
          <div class="user-chip">
            <span>${escapeHtml(displayName(state.user))}</span>
            <button class="ghost-button" data-logout>退出</button>
          </div>
        ` : `
          <button class="hero-button ghost-button" data-open-auth="login">登录 / 注册</button>
        `}
      </div>
    </header>
  `;
}

function renderHero() {
  const stats = state.catStats || {};
  const activeProject = state.hotCrowdfunding[0] || state.crowdfunding[0];
  const selectedAnimal = getSelectedAnimal();

  return `
    <section id="hero" class="hero-panel">
      <div class="hero-copy">
        <span class="section-kicker">校园流浪动物救助平台</span>
        <h1>把领养、救助、纪念、捐赠和个人中心放进同一个温暖入口。</h1>
        <p>
          在这里查看动物档案、提交领养申请、发起救助、参与社区互动，也能随时查看捐赠记录、
          透明账单和个人资料。
        </p>
        <div class="hero-actions">
          <button class="hero-button" data-scroll="adoption">立即查看领养流程</button>
          <button class="hero-button ghost-button" data-scroll="donate">先去为爱发电</button>
        </div>
        <div class="stats-grid">
          ${renderStat('在档动物', stats.totalCount || 0, '含观察中 / 治疗中')}
          ${renderStat('可领养', stats.adoptableCount || 0, '已统一展示为公 / 母')}
          ${renderStat('透明账单', state.financeRecords.length, '公开收支明细')}
          ${renderStat('社区动态', state.dynamics.length, '支持发帖 / 点赞 / 评论')}
        </div>
      </div>
      <aside class="hero-aside">
        <article class="spotlight-card">
          <span class="spotlight-label">当前主推项目</span>
          ${activeProject ? `
            <h2>${escapeHtml(activeProject.title)}</h2>
            <p>${escapeHtml(activeProject.description || '公开筹款项目')}</p>
            <div class="spotlight-progress">
              <div class="progress-track"><span style="width:${Math.min(activeProject.progress || 0, 100)}%"></span></div>
              <div class="progress-meta">
                <strong>${currency(activeProject.currentAmount || 0)}</strong>
                <span>/ ${currency(activeProject.targetAmount || 0)}</span>
              </div>
            </div>
            <button class="inline-link" data-scroll="donate" data-fill-project="${activeProject.id}">
              用 1 / 5 / 10 元快速支持
            </button>
          ` : `
            <p>众筹项目加载中。</p>
          `}
        </article>
        <article class="feature-animal">
          <span class="spotlight-label">本周推荐动物档案</span>
          ${selectedAnimal ? `
            <img src="${escapeAttr(imageUrl(selectedAnimal.coverImage))}" alt="${escapeAttr(selectedAnimal.name)}">
            <div class="feature-animal-body">
              <h3>${escapeHtml(selectedAnimal.name)}</h3>
              <p>${escapeHtml(selectedAnimal.description || selectedAnimal.rescueStory || '等待被看见的校园小伙伴。')}</p>
              <button class="inline-link" data-adoption-target="${selectedAnimal.id}">
                设为领养对象
              </button>
            </div>
          ` : '<p>动物档案加载中。</p>'}
        </article>
      </aside>
    </section>
  `;
}

function renderArchiveSection() {
  const animals = filteredAnimals();
  const selected = getSelectedAnimal();
  const locations = uniqueStrings(state.cats.map((item) => item.rescueLocation));

  return `
    <section id="archive" class="content-section">
      <div class="section-heading">
        <div>
          <span class="section-kicker">一、动物档案</span>
          <h2>可检索的动物档案已经接入统一入口。</h2>
        </div>
        <form id="archive-search-form" class="compact-form">
          <input id="archive-keyword" name="keyword" placeholder="搜索动物名称、品种、地点" value="${escapeAttr(state.archiveFilters.keyword)}">
          <select id="archive-status" name="status">
            ${renderOptions([
              ['', '全部状态'],
              ['ADOPTABLE', '可领养'],
              ['ADOPTED', '已领养'],
              ['OBSERVATION', '观察中'],
              ['TREATMENT', '治疗中']
            ], state.archiveFilters.status)}
          </select>
          <select id="archive-gender" name="gender">
            ${renderOptions([
              ['', '全部性别'],
              ['1', '公'],
              ['0', '母']
            ], state.archiveFilters.gender)}
          </select>
          <button class="pill-button" type="submit">检索</button>
          <button class="pill-button ghost" type="button" data-reset-archive>重置</button>
        </form>
      </div>
      <div class="archive-layout">
        <article class="feature-sheet">
          ${selected ? `
            <div class="sheet-cover">
              <img src="${escapeAttr(imageUrl(selected.coverImage))}" alt="${escapeAttr(selected.name)}">
              <button class="favorite-toggle ${isFavorite(selected.id) ? 'is-active' : ''}" type="button" data-toggle-favorite="${selected.id}">
                ${isFavorite(selected.id) ? '已收藏' : '加入收藏'}
              </button>
            </div>
            <div class="sheet-body">
              <div class="sheet-title-row">
                <div>
                  <span class="sheet-eyebrow">Animal File</span>
                  <h3>${escapeHtml(selected.name)}</h3>
                </div>
                <span class="status-pill ${toneForAnimal(selected.status)}">${escapeHtml(selected.statusText || selected.status || '在档')}</span>
              </div>
              <div class="sheet-metrics">
                ${renderInfoChip('性别', selected.genderText || genderText(selected.gender))}
                ${renderInfoChip('年龄', selected.age || '待补充')}
                ${renderInfoChip('颜色', selected.color || '待补充')}
                ${renderInfoChip('校区位置', selected.rescueLocation || '待补充')}
              </div>
              <p class="sheet-copy">${escapeHtml(selected.description || selected.rescueStory || '暂无补充说明。')}</p>
              <div class="sheet-grid">
                <div><span>健康状态</span><strong>${escapeHtml(selected.healthStatus || '待观察')}</strong></div>
                <div><span>绝育情况</span><strong>${truthText(selected.isSterilized)}</strong></div>
                <div><span>疫苗情况</span><strong>${truthText(selected.isVaccinated)}</strong></div>
                <div><span>互动热度</span><strong>${(selected.likeCount || 0) + (selected.viewCount || 0)} 次</strong></div>
              </div>
              <div class="sheet-actions">
                <button class="hero-button" data-adoption-target="${selected.id}">申请领养</button>
                <button class="hero-button ghost-button" data-scroll="community">去看社区动态</button>
              </div>
            </div>
          ` : `
            <div class="empty-block">暂无可展示的动物档案。</div>
          `}
        </article>
        <div class="animal-column">
          <div class="inline-note">
            <span>可检索字段</span>
            <strong>${animals.length}</strong>
            <small>名称 / 状态 / 性别 / 校园地点</small>
          </div>
          <div class="animal-grid">
            ${animals.map((item) => renderAnimalCard(item)).join('') || '<div class="empty-card">没有找到符合条件的动物。</div>'}
          </div>
          <div class="location-strips">
            ${locations.slice(0, 6).map((location) => `<span>${escapeHtml(location)}</span>`).join('')}
          </div>
        </div>
      </div>
    </section>
  `;
}

function renderAdoptionSection() {
  const selected = getSelectedAnimal();
  const applications = state.applications.slice(0, 5);

  return `
    <section id="adoption" class="content-section">
      <div class="section-heading">
        <div>
          <span class="section-kicker">二、在线领养</span>
          <h2>从浏览档案到提交申请，把领养流程放到清晰顺手的一条线上。</h2>
        </div>
        <button class="pill-button ghost" type="button" data-scroll="profile">查看个人中心</button>
      </div>
      <div class="flow-board">
        ${[
          ['1', '浏览档案', '先看动物档案，确认性格、健康状态和校园地点。'],
          ['2', '填写申请', '提交领养理由、居住条件、经验和联系信息。'],
          ['3', '等待审核', '系统会根据认证状态和申请信息进入审核。'],
          ['4', '线下接触', '通过后安排见面互动，确认是否适配。'],
          ['5', '完成领养', '交接后进入回访期，形成闭环。']
        ].map(([idx, title, desc]) => `
          <article class="flow-step">
            <span>${idx}</span>
            <h3>${title}</h3>
            <p>${desc}</p>
          </article>
        `).join('')}
      </div>
      <div class="adoption-layout">
        <aside class="adoption-side">
          <article class="stack-card">
            <h3>领养须知</h3>
            <ul class="check-list">
              <li>年满 18 周岁，有稳定居住空间。</li>
              <li>愿意承担疫苗、绝育、复诊和日常护理成本。</li>
              <li>接受封窗、隔离和适应期观察。</li>
              <li>承诺不弃养，并愿意配合回访。</li>
            </ul>
          </article>
          <article class="stack-card">
            <h3>领养准备</h3>
            <ul class="check-list">
              <li>猫砂盆、食碗、水碗、航空箱、抓板。</li>
              <li>基础医疗预算和熟悉的宠物医院。</li>
              <li>家中已有宠物时，先做好隔离。</li>
              <li>预留适应期，避免刚到家就高强度社交。</li>
            </ul>
          </article>
          ${applications.length ? `
            <article class="stack-card">
              <h3>我的申请状态</h3>
              <div class="mini-list">
                ${applications.map((item) => `
                  <div class="mini-row">
                    <strong>${escapeHtml(item.catName || `动物 #${item.catId}`)}</strong>
                    <span>${escapeHtml(item.statusText || item.status || '待处理')}</span>
                  </div>
                `).join('')}
              </div>
            </article>
          ` : ''}
        </aside>
        <article class="form-card">
          <div class="form-card-header">
            <div>
              <span class="sheet-eyebrow">Selected Animal</span>
              <h3>${selected ? escapeHtml(selected.name) : '请先从动物档案选择对象'}</h3>
            </div>
            ${selected ? `<span class="status-pill ${toneForAnimal(selected.status)}">${escapeHtml(selected.statusText || selected.status || '')}</span>` : ''}
          </div>
          ${!state.user ? `
            <div class="empty-block">
              <p>登录后可填写申请信息并查看审核进度。</p>
              <button class="hero-button" data-open-auth="login">先登录再申请</button>
            </div>
          ` : `
            <div class="verification-banner ${state.verified ? 'ok' : 'warn'}">
              <div>
                <strong>${state.verified ? '身份认证已通过' : '当前账号尚未完成身份认证'}</strong>
                <span>${state.verified ? '可以直接提交领养申请。' : '申请领养前请先去个人中心完成身份认证。'}</span>
              </div>
              ${state.verified ? '' : '<button class="pill-button ghost" type="button" data-scroll="verification-center">去做认证</button>'}
            </div>
            <form id="adoption-form" class="section-form">
              <div class="field-grid two-cols">
                <label>
                  <span>领养理由</span>
                  <textarea id="adoption-reason" rows="4" placeholder="为什么想领养这只动物？">${escapeHtml(state.adoptionForm.reason)}</textarea>
                </label>
                <label>
                  <span>居住条件</span>
                  <textarea id="adoption-living" rows="4" placeholder="例如是否独居、封窗情况、是否有稳定陪伴时间。">${escapeHtml(state.adoptionForm.livingCondition)}</textarea>
                </label>
                <label>
                  <span>照顾经验</span>
                  <textarea id="adoption-experience" rows="4" placeholder="请说明是否有养宠、绝育、喂药、就医等经验。">${escapeHtml(state.adoptionForm.experience)}</textarea>
                </label>
                <div class="field-stack">
                  <label>
                    <span>联系电话</span>
                    <input id="adoption-phone" value="${escapeAttr(state.adoptionForm.contactPhone)}" placeholder="11 位手机号">
                  </label>
                  <label>
                    <span>联系地址</span>
                    <input id="adoption-address" value="${escapeAttr(state.adoptionForm.contactAddress)}" placeholder="宿舍 / 社区 / 详细门牌">
                  </label>
                </div>
              </div>
              <div class="form-actions">
                <button class="hero-button" type="submit">提交领养申请</button>
                <button class="hero-button ghost-button" type="button" data-scroll="profile">去个人中心补资料</button>
              </div>
            </form>
          `}
        </article>
      </div>
    </section>
  `;
}

function renderRescueSection() {
  const rescueItems = state.rescueLocked ? [] : state.rescues;
  const locationSeeds = uniqueStrings([
    ...CAMPUS_POINTS.map((item) => item.label),
    ...rescueItems.map((item) => item.location)
  ]);

  return `
    <section id="rescue" class="content-section">
      <div class="section-heading">
        <div>
          <span class="section-kicker">三、救助中心</span>
          <h2>覆盖走失、受伤、疾病、绝育和物资支援，让每一次求助都有人接力。</h2>
        </div>
        <button class="pill-button ghost" type="button" data-scroll="community">发布到社区动态</button>
      </div>
      <div class="support-rail">
        <article class="support-card">
          <h3>校园地图选点</h3>
          <p>点击校园平面图快速选择位置，也可以结合下方常用点位补充填写。</p>
          <div class="campus-map">
            <div class="campus-map-grid"></div>
            ${CAMPUS_POINTS.map((item) => `
              <button
                class="map-pin ${state.rescueForm.location === item.label ? 'is-active' : ''}"
                type="button"
                style="left:${item.x};top:${item.y};"
                data-use-location="${escapeAttr(item.label)}"
              >
                <span>${escapeHtml(item.label)}</span>
              </button>
            `).join('')}
          </div>
          <div class="chip-row">
            ${locationSeeds.slice(0, 6).map((item) => `
              <button class="chip-button" type="button" data-use-location="${escapeAttr(item)}">${escapeHtml(item)}</button>
            `).join('')}
          </div>
        </article>
        <article class="support-card">
          <h3>校园公益兽医入口</h3>
          <p>提供值班时段、联系方式和擅长方向，方便根据现场情况快速联系协助。</p>
          <div class="vet-directory">
            <div>
              <strong>公益兽医值班</strong>
              <span>周一至周五 18:00-21:00</span>
            </div>
            <div>
              <strong>联络电话</strong>
              <span>010-12345678</span>
            </div>
            <div>
              <strong>擅长方向</strong>
              <span>外伤处理 / 疾病初筛 / 绝育评估</span>
            </div>
          </div>
          <div class="helper-links">
            <button class="inline-link" type="button" data-scroll="rescue">查看待响应救助</button>
            <button class="inline-link" type="button" data-scroll="donate">登记物资支援</button>
          </div>
        </article>
      </div>
      <div class="rescue-layout">
        <div class="rescue-feed">
          ${state.rescueLocked ? `
            <div class="empty-block">
              <p>登录后可查看联系人、紧急程度和一键参与入口。</p>
              <button class="hero-button" data-open-auth="login">登录后查看救助列表</button>
            </div>
          ` : rescueItems.map((item) => renderRescueCard(item)).join('') || '<div class="empty-card">暂无救助信息。</div>'}
        </div>
        <article class="form-card">
          <div class="form-card-header">
            <div>
              <span class="sheet-eyebrow">Publish Rescue</span>
              <h3>发布救助信息</h3>
            </div>
            <span class="status-pill neutral">支持发布 / 响应 / 完成确认</span>
          </div>
          ${!state.user ? `
            <div class="empty-block">
              <p>登录后可发布救助信息、参与救助和完成确认。</p>
              <button class="hero-button" data-open-auth="login">先登录</button>
            </div>
          ` : `
            <form id="rescue-form" class="section-form">
              <div class="field-grid two-cols">
                <label>
                  <span>标题</span>
                  <input id="rescue-title" value="${escapeAttr(state.rescueForm.title)}" placeholder="例如：图书馆后面发现受伤动物">
                </label>
                <label>
                  <span>救助主题</span>
                  <select id="rescue-topic">
                    ${renderOptions([
                      ['INJURED', '受伤救助'],
                      ['LOST', '走失寻找'],
                      ['DISEASE', '疾病医疗'],
                      ['STERILIZATION', '绝育支持'],
                      ['MATERIAL', '物资求助'],
                      ['EMERGENCY', '特急处理']
                    ], state.rescueForm.topic)}
                  </select>
                </label>
                <label>
                  <span>校园位置</span>
                  <input id="rescue-location" value="${escapeAttr(state.rescueForm.location)}" placeholder="可用上方点位快速填写">
                </label>
                <label>
                  <span>联系方式</span>
                  <input id="rescue-phone" value="${escapeAttr(state.rescueForm.contactPhone)}" placeholder="便于志愿者和管理员对接">
                </label>
                <label>
                  <span>紧急程度</span>
                  <select id="rescue-priority">
                    ${renderOptions([
                      ['0', '普通'],
                      ['1', '紧急'],
                      ['2', '特急']
                    ], String(state.rescueForm.priority))}
                  </select>
                </label>
                <label>
                  <span>救助图片</span>
                  <input id="rescue-image-file" type="file" accept="image/*" ${state.uploadingField === 'rescue-image' ? 'disabled' : ''}>
                  <small>${state.rescueForm.imagePath ? `已上传: ${escapeHtml(state.rescueForm.imagePath)}` : '支持上传现场图片，方便志愿者快速判断情况。'}</small>
                </label>
                <label class="toggle-label">
                  <span>需要公益兽医介入</span>
                  <input id="rescue-needs-vet" type="checkbox" ${state.rescueForm.needsVet ? 'checked' : ''}>
                </label>
                <label class="full-span">
                  <span>情况说明</span>
                  <textarea id="rescue-description" rows="5" placeholder="请描述受伤、失踪、疾病、绝育或物资诉求的具体情况。">${escapeHtml(state.rescueForm.description)}</textarea>
                </label>
              </div>
              <div class="form-actions">
                <button class="hero-button" type="submit">发布救助</button>
              </div>
            </form>
          `}
        </article>
      </div>
    </section>
  `;
}

function renderDonationSection() {
  const projectId = Number(state.donationForm.crowdfundingId || state.crowdfunding[0]?.id || 0);
  const activeProject = state.crowdfunding.find((item) => item.id === projectId) || state.crowdfunding[0];

  return `
    <section id="donate" class="content-section">
      <div class="section-heading">
        <div>
          <span class="section-kicker">四、为爱发电</span>
          <h2>把捐赠、打赏、众筹和账单透明化放到社区前面。</h2>
        </div>
        <button class="pill-button ghost" type="button" data-scroll="community">再去看社区</button>
      </div>
      <div class="donate-layout">
        <article class="donate-lead">
          <div class="donate-highlight">
            <span class="sheet-eyebrow">Quick Support</span>
            <h3>${escapeHtml(activeProject?.title || '选择一个正在进行的项目')}</h3>
            <p>${escapeHtml(activeProject?.description || '支持治疗、绝育、猫粮、药品和校园救助日常开销。')}</p>
            ${activeProject ? `
              <div class="progress-track large"><span style="width:${Math.min(activeProject.progress || 0, 100)}%"></span></div>
              <div class="quick-amounts">
                ${[1, 5, 10].map((amount) => `
                  <button class="chip-button ${Number(state.donationForm.amount) === amount ? 'is-active' : ''}" type="button" data-quick-amount="${amount}" data-project-id="${activeProject.id}">
                    ${amount} 元
                  </button>
                `).join('')}
              </div>
            ` : ''}
          </div>
          <form id="donation-form" class="section-form donate-form">
            <div class="field-grid two-cols">
              <label>
                <span>支持项目</span>
                <select id="donation-project">
                  ${renderOptions(state.crowdfunding.map((item) => [String(item.id), item.title]), state.donationForm.crowdfundingId)}
                </select>
              </label>
              <label>
                <span>金额</span>
                <input id="donation-amount" type="number" min="1" step="1" value="${escapeAttr(state.donationForm.amount)}">
              </label>
              <label>
                <span>支付方式</span>
                <select id="donation-method">
                  ${renderOptions([
                    ['WECHAT', '微信'],
                    ['ALIPAY', '支付宝']
                  ], state.donationForm.paymentMethod)}
                </select>
              </label>
              <label class="toggle-label">
                <span>匿名支持</span>
                <input id="donation-anonymous" type="checkbox" ${state.donationForm.isAnonymous ? 'checked' : ''}>
              </label>
              <label class="full-span">
                <span>留言</span>
                <textarea id="donation-message" rows="3" placeholder="给项目留一句鼓励。">${escapeHtml(state.donationForm.message)}</textarea>
              </label>
            </div>
            <div class="form-actions">
              <button class="hero-button" type="submit">${state.user ? '提交支持' : '登录后支持'}</button>
            </div>
          </form>
        </article>
        <div class="donate-column">
          <article class="stack-card">
            <h3>众筹项目</h3>
            <div class="project-list">
              ${state.crowdfunding.map((item) => `
                <article class="project-card">
                  <div class="project-header">
                    <div>
                      <strong>${escapeHtml(item.title)}</strong>
                      <small>${escapeHtml(item.catName || '校园动物项目')}</small>
                    </div>
                    <span class="status-pill accent">${escapeHtml(item.statusText || '进行中')}</span>
                  </div>
                  <p>${escapeHtml(item.description || '暂无描述')}</p>
                  <div class="progress-track"><span style="width:${Math.min(item.progress || 0, 100)}%"></span></div>
                  <div class="project-meta">
                    <span>${currency(item.currentAmount || 0)} / ${currency(item.targetAmount || 0)}</span>
                    <button class="inline-link" type="button" data-fill-project="${item.id}" data-scroll="donate">支持这个项目</button>
                  </div>
                </article>
              `).join('')}
            </div>
          </article>
          <article class="stack-card">
            <h3>账单透明化</h3>
            <div class="ledger-table">
              ${state.financeRecords.slice(0, 8).map((item) => `
                <div class="ledger-row">
                  <div>
                    <strong>${escapeHtml(item.category || item.typeText || '账单')}</strong>
                    <small>${escapeHtml(item.description || '')}</small>
                  </div>
                  <span class="${item.type === 'EXPENSE' ? 'amount-out' : 'amount-in'}">
                    ${item.type === 'EXPENSE' ? '-' : '+'}${currency(item.amount || 0)}
                  </span>
                </div>
              `).join('')}
            </div>
          </article>
          <article class="stack-card">
            <h3>实物捐赠预约</h3>
            <form id="material-form" class="section-form slim-form">
              <label><span>联系人</span><input id="material-name" value="${escapeAttr(state.materialForm.contactName)}" placeholder="姓名"></label>
              <label><span>手机号</span><input id="material-phone" value="${escapeAttr(state.materialForm.contactPhone)}" placeholder="联系电话"></label>
              <label>
                <span>物资类型</span>
                <select id="material-type">
                  ${renderOptions([
                    ['CAT_FOOD', '猫粮'],
                    ['DOG_FOOD', '狗粮'],
                    ['CAT_LITTER', '猫砂'],
                    ['MEDICINE', '药品'],
                    ['SUPPLIES', '笼包 / 毯子 / 清洁用品']
                  ], state.materialForm.itemType)}
                </select>
              </label>
              <label><span>数量说明</span><input id="material-quantity" value="${escapeAttr(state.materialForm.quantity)}" placeholder="例如：猫粮 5kg"></label>
              <label><span>校园捐赠点</span><input id="material-point" value="${escapeAttr(state.materialForm.pickupPoint)}"></label>
              <label><span>备注</span><textarea id="material-note" rows="3" placeholder="送达时间或核销说明。">${escapeHtml(state.materialForm.note)}</textarea></label>
              <button class="hero-button" type="submit">${state.user ? '登记物资预约' : '登录后登记预约'}</button>
            </form>
            <div class="warning-box">
              预约提交后会进入物资支援流程，便于志愿者跟进接收和线下核销。
            </div>
            <div class="mini-list">
              ${(state.materialAppointments || []).slice(0, 4).map((item) => `
                <div class="mini-row">
                  <div>
                    <strong>${escapeHtml(item.itemTypeText)}</strong>
                    <small>${escapeHtml(item.pickupPoint)}</small>
                  </div>
                  <span>${escapeHtml(normalizeMaterialSyncStatus(item.syncStatus))}</span>
                </div>
              `).join('') || '<div class="empty-mini">还没有物资预约记录。</div>'}
            </div>
          </article>
        </div>
      </div>
    </section>
  `;
}

function renderCommunitySection() {
  const feed = filteredDynamics();

  return `
    <section id="community" class="content-section">
      <div class="section-heading">
        <div>
          <span class="section-kicker">五、社区动态</span>
          <h2>保留发帖、点赞、评论，再补一块知识 / 日常 / 讣告纪念的内容组织。</h2>
        </div>
        <div class="tab-strip">
          ${[
            ['all', '全部'],
            ['science', '知识科普'],
            ['daily', '动物日常'],
            ['memorial', '讣告纪念']
          ].map(([key, label]) => `
            <button class="tab-button ${state.communityFilter === key ? 'is-active' : ''}" type="button" data-community-filter="${key}">
              ${label}
            </button>
          `).join('')}
        </div>
      </div>
      <div class="community-layout">
        <div class="community-feed">
          ${feed.map((item) => renderDynamicCard(item)).join('')}
          ${state.communityFilter === 'memorial' ? renderMemorialCard() : ''}
        </div>
        <aside class="community-side">
          <article class="stack-card">
            <h3>发布动态</h3>
            ${!state.user ? `
              <div class="empty-block">
                <p>登录后可以发布知识科普、动物日常或纪念动态。</p>
                <button class="hero-button" data-open-auth="login">登录后发帖</button>
              </div>
            ` : `
              <form id="dynamic-form" class="section-form slim-form">
                <label>
                  <span>动态类型</span>
                  <select id="dynamic-type">
                    ${renderOptions([
                      ['UPDATE', '进展更新'],
                      ['PHOTO', '日常照片'],
                      ['FEED', '投喂记录']
                    ], state.dynamicForm.type)}
                  </select>
                </label>
                <label><span>位置</span><input id="dynamic-location" value="${escapeAttr(state.dynamicForm.location)}" placeholder="例如：图书馆东侧"></label>
                <label><span>图片链接</span><input id="dynamic-image" value="${escapeAttr(state.dynamicForm.imagePath)}" placeholder="/uploads/dynamic/d1.jpg"></label>
                <label><span>内容</span><textarea id="dynamic-content" rows="5" placeholder="分享知识科普、日常观察或纪念文字。">${escapeHtml(state.dynamicForm.content)}</textarea></label>
                <button class="hero-button" type="submit">发布动态</button>
              </form>
            `}
          </article>
          ${renderMemorialCard()}
        </aside>
      </div>
    </section>
  `;
}

function renderVerificationPanel() {
  const record = state.verificationRecord || {};
  const status = record.status || state.verificationStatus || 'UNSUBMITTED';
  const locked = state.verified || status === 'PENDING';
  const canWithdraw = Boolean(record.id && status === 'PENDING');
  const canSubmit = !state.verified && (!record.id || status === 'REJECTED' || status === 'WITHDRAWN' || status === 'UNSUBMITTED');
  const submitLabel = record.id && status === 'REJECTED' ? '重新提交认证' : '提交认证申请';

  return `
    <article id="verification-center" class="stack-card verification-center">
      <div class="card-headline">
        <div>
          <h3>身份认证中心</h3>
          <p>${state.verified ? '当前账号已通过认证，可以直接参与领养与救助流程。' : '支持学号唯一性校验、证件图片上传和申请状态追踪。'}</p>
        </div>
        <span class="status-pill ${toneForVerification(status)}">${escapeHtml(verificationStatusText(status))}</span>
      </div>
      <div class="verification-summary">
        <div><span>认证类型</span><strong>${escapeHtml(verificationTypeText(record.verificationType || state.verificationForm.verificationType || 'STUDENT'))}</strong></div>
        <div><span>实名信息</span><strong>${escapeHtml(record.realName || state.profileForm.realName || '待填写')}</strong></div>
        <div><span>学号 / 工号</span><strong>${escapeHtml(record.studentId || state.profileForm.studentId || '待填写')}</strong></div>
        <div><span>身份证号</span><strong>${escapeHtml(maskIdCard(record.idCard || state.verificationForm.idCard))}</strong></div>
      </div>
      ${record.rejectReason ? `<div class="warning-box">上次驳回原因：${escapeHtml(record.rejectReason)}</div>` : ''}
      <form id="verification-form" class="section-form">
        <div class="field-grid two-cols">
          <label>
            <span>所属高校</span>
            <select id="verification-university" ${locked ? 'disabled' : ''}>
              ${renderOptions((state.universities.length ? state.universities : DEFAULT_UNIVERSITIES).map((item) => [String(item.id), item.name]), state.verificationForm.universityId)}
            </select>
          </label>
          <label>
            <span>认证类型</span>
            <select id="verification-type" ${locked ? 'disabled' : ''}>
              ${renderOptions([
                ['STUDENT', '学生认证'],
                ['STAFF', '教职工认证'],
                ['VOLUNTEER', '志愿者认证']
              ], state.verificationForm.verificationType)}
            </select>
          </label>
          <label>
            <span>真实姓名</span>
            <input id="verification-realname" value="${escapeAttr(state.verificationForm.realName)}" ${locked ? 'disabled' : ''}>
          </label>
          <label>
            <span>院系 / 部门</span>
            <input id="verification-department" value="${escapeAttr(state.verificationForm.department)}" ${locked ? 'disabled' : ''}>
          </label>
          <label>
            <span>学号 / 工号</span>
            <input id="verification-studentid" value="${escapeAttr(state.verificationForm.studentId)}" ${locked ? 'disabled' : ''}>
          </label>
          <label>
            <span>身份证号</span>
            <input id="verification-idcard" value="${escapeAttr(state.verificationForm.idCard)}" ${locked ? 'disabled' : ''}>
          </label>
          <label>
            <span>身份证正面</span>
            <input id="verification-id-front-file" type="file" accept="image/*" ${locked || state.uploadingField === 'verification-id-front' ? 'disabled' : ''}>
            <small>${state.verificationForm.idCardFront ? `已上传: ${escapeHtml(state.verificationForm.idCardFront)}` : '请上传清晰图片'}</small>
          </label>
          <label>
            <span>身份证反面</span>
            <input id="verification-id-back-file" type="file" accept="image/*" ${locked || state.uploadingField === 'verification-id-back' ? 'disabled' : ''}>
            <small>${state.verificationForm.idCardBack ? `已上传: ${escapeHtml(state.verificationForm.idCardBack)}` : '请上传清晰图片'}</small>
          </label>
          <label class="full-span">
            <span>学生证 / 工作证</span>
            <input id="verification-student-card-file" type="file" accept="image/*" ${locked || state.uploadingField === 'verification-student-card' ? 'disabled' : ''}>
            <small>${state.verificationForm.studentCard ? `已上传: ${escapeHtml(state.verificationForm.studentCard)}` : '用于辅助审核'}</small>
          </label>
        </div>
        <div class="form-actions">
          ${state.verified ? '<button class="hero-button" type="button" disabled>认证已完成</button>' : `<button class="hero-button" type="submit" ${canSubmit ? '' : 'disabled'}>${submitLabel}</button>`}
          ${canWithdraw ? '<button class="hero-button ghost-button" type="button" data-withdraw-verification>撤回当前申请</button>' : ''}
        </div>
      </form>
    </article>
  `;
}

function renderProfileSection() {
  const favoriteAnimals = state.favorites
    .map((id) => state.cats.find((item) => item.id === id))
    .filter(Boolean);
  const historyAnimals = state.history
    .map((id) => state.cats.find((item) => item.id === id))
    .filter(Boolean);

  return `
    <section id="profile" class="content-section">
      <div class="section-heading">
        <div>
          <span class="section-kicker">六、个人中心</span>
          <h2>把个人信息、收藏、申请、浏览历史和捐赠记录集中到一个页面里。</h2>
        </div>
      </div>
      <div class="profile-layout">
        <aside class="profile-sidebar">
          <article class="profile-card">
            <div class="avatar-disc">${escapeHtml((displayName(state.user)[0] || '访').slice(0, 1))}</div>
            <h3>${state.user ? escapeHtml(displayName(state.user)) : '访客用户'}</h3>
            <p>${state.user ? escapeHtml(state.user.roleText || '普通用户') : '登录 / 注册后可查看完整个人信息'}</p>
            ${state.user ? `
              <button class="hero-button ghost-button" data-logout>退出登录</button>
            ` : `
              <button class="hero-button" data-open-auth="login">登录 / 注册</button>
            `}
          </article>
          <nav class="profile-nav">
            <span>个人信息</span>
            <span>我的收藏</span>
            <span>领养申请</span>
            <span>浏览历史</span>
            <span>账号设置</span>
            <span>帮助中心</span>
          </nav>
        </aside>
        <div class="profile-main">
          ${state.user ? `
            <article class="stack-card">
              <div class="card-headline">
                <h3>个人信息</h3>
                <span class="status-pill ${state.verified ? 'success' : 'warning'}">${state.verified ? '认证已通过' : '未认证'}</span>
              </div>
              <form id="profile-form" class="section-form">
                <div class="field-grid two-cols">
                  <label><span>用户名</span><input id="profile-username" value="${escapeAttr(state.profileForm.username)}" disabled></label>
                  <label><span>真实姓名</span><input id="profile-realname" value="${escapeAttr(state.profileForm.realName)}"></label>
                  <label><span>学号 / 工号</span><input id="profile-studentid" value="${escapeAttr(state.profileForm.studentId)}"></label>
                  <label><span>手机号</span><input id="profile-phone" value="${escapeAttr(state.profileForm.phone)}"></label>
                  <label><span>邮箱</span><input id="profile-email" value="${escapeAttr(state.profileForm.email)}"></label>
                  <label><span>院系</span><input id="profile-college" value="${escapeAttr(state.profileForm.college)}"></label>
                  <label><span>性别</span>
                    <select id="profile-gender">
                      ${renderOptions([
                        ['', '未填写'],
                        ['1', '男'],
                        ['0', '女']
                      ], String(state.profileForm.gender))}
                    </select>
                  </label>
                  <label class="full-span"><span>个人介绍</span><textarea id="profile-introduction" rows="4">${escapeHtml(state.profileForm.introduction)}</textarea></label>
                </div>
                <div class="form-actions">
                  <button class="hero-button" type="submit">保存个人信息</button>
                </div>
              </form>
            </article>
            ${renderVerificationPanel()}
            <div class="profile-grid">
              <article class="stack-card">
                <h3>我的收藏</h3>
                <div class="mini-cards">
                  ${favoriteAnimals.map((item) => renderMiniAnimal(item)).join('') || '<div class="empty-mini">还没有收藏的动物。</div>'}
                </div>
              </article>
              <article class="stack-card">
                <h3>浏览历史</h3>
                <div class="mini-cards">
                  ${historyAnimals.map((item) => renderMiniAnimal(item)).join('') || '<div class="empty-mini">先去动物档案逛一逛。</div>'}
                </div>
              </article>
            </div>
            <article class="stack-card">
              <h3>领养申请状态</h3>
              ${state.applications.length ? `
                <div class="table-shell">
                  ${state.applications.map((item) => `
                    <div class="table-row">
                      <div>
                        <strong>${escapeHtml(item.catName || `动物 #${item.catId}`)}</strong>
                        <small>${escapeHtml(item.contactPhone || '')}</small>
                      </div>
                      <span>${escapeHtml(item.createTime ? formatDate(item.createTime) : '')}</span>
                      <span class="status-pill ${toneForStatus(item.status)}">${escapeHtml(item.statusText || item.status || '待处理')}</span>
                    </div>
                  `).join('')}
                </div>
              ` : '<div class="empty-mini">暂无领养申请记录。</div>'}
            </article>
            <article class="stack-card">
              <h3>我的支持记录</h3>
              ${state.donations.length ? `
                <div class="table-shell">
                  ${state.donations.map((item) => `
                    <div class="table-row">
                      <div>
                        <strong>${escapeHtml(item.crowdfundingTitle || item.catName || '爱心支持')}</strong>
                        <small>${escapeHtml(item.paymentMethod || '线上支付')}</small>
                      </div>
                      <span>${currency(item.amount || 0)}</span>
                      <span class="status-pill success">${escapeHtml(item.statusText || item.status || '成功')}</span>
                    </div>
                  `).join('')}
                </div>
              ` : '<div class="empty-mini">暂无支持记录。</div>'}
            </article>
            <article class="stack-card">
              <h3>帮助中心</h3>
              <ul class="help-list">
                <li>申请领养前，请先在个人中心完成身份认证并等待审核。</li>
                <li>救助发布支持联系人、校园位置、紧急程度和公益兽医入口。</li>
                <li>为爱发电模块已接通众筹、打赏、实物预约和公开账单。</li>
                <li>收藏、申请和支持记录都可以在这里集中查看与整理。</li>
              </ul>
            </article>
          ` : `
            <article class="stack-card guest-profile">
              <h3>个人中心预览</h3>
              <p>登录后可以查看个人信息、我的收藏、领养申请、浏览历史、支持记录和帮助中心。</p>
              <button class="hero-button" data-open-auth="login">立即登录</button>
            </article>
          `}
        </div>
      </div>
    </section>
  `;
}

function renderAuthModal() {
  if (!state.authModalOpen) return '';

  return `
    <div class="modal-backdrop" data-close-auth>
      <div class="auth-modal" role="dialog" aria-modal="true" aria-label="登录或注册" onclick="event.stopPropagation()">
        <div class="modal-header">
          <div>
            <span class="section-kicker">Access Portal</span>
            <h2>${state.authMode === 'login' ? '登录系统' : '注册新账号'}</h2>
          </div>
          <button class="icon-button" type="button" data-close-auth>关闭</button>
        </div>
        <div class="auth-tabs">
          <button class="tab-button ${state.authMode === 'login' ? 'is-active' : ''}" type="button" data-auth-mode="login">登录</button>
          <button class="tab-button ${state.authMode === 'register' ? 'is-active' : ''}" type="button" data-auth-mode="register">注册</button>
        </div>
        <form id="auth-form" class="section-form">
          ${state.authMode === 'register' ? `
            <div class="field-grid two-cols">
              <label><span>真实姓名</span><input id="auth-realname" value="${escapeAttr(state.authForm.realName)}" placeholder="用于社区和领养审核"></label>
              <label><span>手机号</span><input id="auth-phone" value="${escapeAttr(state.authForm.phone)}" placeholder="11 位手机号"></label>
              <label class="full-span"><span>邮箱</span><input id="auth-email" value="${escapeAttr(state.authForm.email)}" placeholder="可选，但推荐填写"></label>
            </div>
          ` : ''}
          <label><span>用户名</span><input id="auth-username" value="${escapeAttr(state.authForm.username)}" placeholder="请输入用户名"></label>
          <label><span>密码</span><input id="auth-password" type="password" value="${escapeAttr(state.authForm.password)}" placeholder="请输入密码"></label>
          <div class="form-actions">
            <button class="hero-button" type="submit">${state.authMode === 'login' ? '立即登录' : '创建账号'}</button>
          </div>
        </form>
      </div>
    </div>
  `;
}

function renderStat(label, value, note) {
  return `
    <article class="stat-card">
      <span>${escapeHtml(label)}</span>
      <strong>${escapeHtml(String(value))}</strong>
      <small>${escapeHtml(note)}</small>
    </article>
  `;
}

function renderAnimalCard(item) {
  return `
    <article class="animal-card ${state.selectedAnimalId === item.id ? 'is-selected' : ''}">
      <img src="${escapeAttr(imageUrl(item.coverImage))}" alt="${escapeAttr(item.name)}">
      <div class="animal-card-body">
        <div class="animal-headline">
          <div>
            <h3>${escapeHtml(item.name)}</h3>
            <small>${escapeHtml(item.breed || '校园动物档案')}</small>
          </div>
          <span class="status-pill ${toneForAnimal(item.status)}">${escapeHtml(item.statusText || item.status || '在档')}</span>
        </div>
        <p>${escapeHtml(item.character || item.description || '暂无补充描述。')}</p>
        <div class="animal-meta">
          <span>${escapeHtml(item.genderText || genderText(item.gender))}</span>
          <span>${escapeHtml(item.age || '年龄待补充')}</span>
          <span>${escapeHtml(item.rescueLocation || '地点待补充')}</span>
        </div>
        <div class="animal-actions">
          <button class="inline-link" type="button" data-select-animal="${item.id}">查看档案</button>
          <button class="inline-link" type="button" data-adoption-target="${item.id}">申请领养</button>
        </div>
      </div>
    </article>
  `;
}

function renderRescueCard(item) {
  const image = publicImageList(item.images)[0];
  return `
    <article class="rescue-card">
      ${image ? `<img src="${escapeAttr(image)}" alt="${escapeAttr(item.title)}">` : ''}
      <div class="rescue-card-body">
        <div class="rescue-title-row">
          <div>
            <h3>${escapeHtml(item.title)}</h3>
            <small>${escapeHtml(item.location || '校园位置待补充')}</small>
          </div>
          <div class="badge-stack">
            <span class="status-pill ${toneForRescue(item.type)}">${escapeHtml(item.typeText || item.type || '救助')}</span>
            <span class="status-pill ${toneForPriority(item.priority)}">${escapeHtml(item.priorityText || priorityText(item.priority))}</span>
          </div>
        </div>
        <p>${escapeHtml(item.description || '暂无说明')}</p>
        <div class="rescue-meta-grid">
          <div><span>联系方式</span><strong>${escapeHtml(item.contactPhone || '未填写')}</strong></div>
          <div><span>进度</span><strong>${escapeHtml(item.statusText || item.status || '待处理')}</strong></div>
          <div><span>救助人</span><strong>${escapeHtml(item.username || item.realName || '匿名')}</strong></div>
          <div><span>闭环确认</span><strong>${item.canClose ? '可确认完成' : '待跟进'}</strong></div>
        </div>
        <div class="rescue-actions">
          ${item.canRespond ? `
            <button class="pill-button" type="button" data-respond-rescue="${item.id}" ${state.rescueBusyId === item.id ? 'disabled' : ''}>
              一键报名参与救助
            </button>
          ` : ''}
          ${item.canClose ? `
            <button class="pill-button ghost" type="button" data-close-rescue="${item.id}" ${state.rescueBusyId === item.id ? 'disabled' : ''}>
              救助完成确认
            </button>
          ` : ''}
        </div>
      </div>
    </article>
  `;
}

function renderDynamicCard(item) {
  const images = publicImageList(item.images);
  const comments = state.comments[item.id] || [];

  return `
    <article class="dynamic-card">
      <div class="dynamic-header">
        <div>
          <span class="sheet-eyebrow">${dynamicLabel(item)}</span>
          <h3>${escapeHtml(item.catName || item.location || '校园动态')}</h3>
        </div>
        <span>${escapeHtml(item.formattedTime || formatDate(item.createTime))}</span>
      </div>
      <p>${escapeHtml(item.content || '')}</p>
      ${images.length ? `
        <div class="dynamic-images">
          ${images.slice(0, 3).map((image) => `<img src="${escapeAttr(imageUrl(image))}" alt="动态图片">`).join('')}
        </div>
      ` : ''}
      <div class="dynamic-actions">
        <button class="inline-link" type="button" data-like-dynamic="${item.id}">点赞 ${item.likeCount || 0}</button>
        <button class="inline-link" type="button" data-load-comments="${item.id}">评论 ${item.commentCount || 0}</button>
      </div>
      ${comments.length ? `
        <div class="comment-list">
          ${comments.map((comment) => `
            <div class="comment-item">
              <strong>${escapeHtml(comment.username || '校园用户')}</strong>
              <span>${escapeHtml(comment.content || '')}</span>
            </div>
          `).join('')}
        </div>
      ` : ''}
      ${state.user ? `
        <form id="comment-form-${item.id}" class="comment-form">
          <input id="comment-input-${item.id}" data-comment-id="${item.id}" value="${escapeAttr(state.commentDrafts[item.id] || '')}" placeholder="写下你的评论">
          <button class="pill-button" type="submit">发送</button>
        </form>
      ` : ''}
    </article>
  `;
}

function renderMemorialCard() {
  return `
    <article class="memorial-card">
      <img src="${memorialStory.image}" alt="${escapeAttr(memorialStory.title)}">
      <div class="memorial-body">
        <span class="section-kicker">讣告纪念</span>
        <h3>${escapeHtml(memorialStory.title)}</h3>
        <p>${escapeHtml(memorialStory.summary)}</p>
      </div>
    </article>
  `;
}

function renderMiniAnimal(item) {
  return `
    <button class="mini-animal" type="button" data-select-animal="${item.id}" data-scroll="archive">
      <img src="${escapeAttr(imageUrl(item.coverImage))}" alt="${escapeAttr(item.name)}">
      <span>${escapeHtml(item.name)}</span>
    </button>
  `;
}

function renderOptions(entries, selected) {
  return entries
    .map(([value, label]) => `<option value="${escapeAttr(value)}" ${String(selected) === String(value) ? 'selected' : ''}>${escapeHtml(label)}</option>`)
    .join('');
}

function renderInfoChip(label, value) {
  return `
    <div class="info-chip">
      <span>${escapeHtml(label)}</span>
      <strong>${escapeHtml(value || '待补充')}</strong>
    </div>
  `;
}

async function handleClick(event) {
  const trigger = event.target.closest('[data-open-auth],[data-close-auth],[data-auth-mode],[data-logout],[data-scroll],[data-select-animal],[data-toggle-favorite],[data-adoption-target],[data-like-dynamic],[data-load-comments],[data-quick-amount],[data-fill-project],[data-respond-rescue],[data-close-rescue],[data-use-location],[data-reset-archive],[data-community-filter],[data-withdraw-verification]');
  if (!trigger) return;

  if (trigger.dataset.openAuth) {
    state.authMode = trigger.dataset.openAuth;
    state.authModalOpen = true;
    render();
    return;
  }

  if (trigger.dataset.closeAuth !== undefined) {
    state.authModalOpen = false;
    render();
    return;
  }

  if (trigger.dataset.authMode) {
    state.authMode = trigger.dataset.authMode;
    render();
    return;
  }

  if (trigger.dataset.logout !== undefined) {
    clearAuth();
    await loadPublicData();
    render();
    showToast('已退出登录', 'success');
    return;
  }

  if (trigger.dataset.scroll) {
    const section = document.getElementById(trigger.dataset.scroll);
    if (section) {
      section.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
    if (trigger.dataset.fillProject) {
      state.donationForm.crowdfundingId = trigger.dataset.fillProject;
      render();
    }
    return;
  }

  if (trigger.dataset.selectAnimal) {
    state.selectedAnimalId = Number(trigger.dataset.selectAnimal);
    rememberHistory(state.selectedAnimalId);
    render();
    return;
  }

  if (trigger.dataset.toggleFavorite) {
    toggleFavorite(Number(trigger.dataset.toggleFavorite));
    render();
    return;
  }

  if (trigger.dataset.adoptionTarget) {
    state.selectedAnimalId = Number(trigger.dataset.adoptionTarget);
    rememberHistory(state.selectedAnimalId);
    render();
    const section = document.getElementById('adoption');
    if (section) section.scrollIntoView({ behavior: 'smooth', block: 'start' });
    return;
  }

  if (trigger.dataset.likeDynamic) {
    await likeDynamic(Number(trigger.dataset.likeDynamic));
    return;
  }

  if (trigger.dataset.loadComments) {
    await loadComments(Number(trigger.dataset.loadComments));
    return;
  }

  if (trigger.dataset.quickAmount) {
    state.donationForm.amount = Number(trigger.dataset.quickAmount);
    if (trigger.dataset.projectId) {
      state.donationForm.crowdfundingId = trigger.dataset.projectId;
    }
    render();
    return;
  }

  if (trigger.dataset.respondRescue) {
    await respondRescue(Number(trigger.dataset.respondRescue));
    return;
  }

  if (trigger.dataset.closeRescue) {
    await closeRescue(Number(trigger.dataset.closeRescue));
    return;
  }

  if (trigger.dataset.useLocation) {
    state.rescueForm.location = trigger.dataset.useLocation;
    render();
    return;
  }

  if (trigger.dataset.communityFilter) {
    state.communityFilter = trigger.dataset.communityFilter;
    render();
    return;
  }

  if (trigger.dataset.withdrawVerification !== undefined) {
    await withdrawVerification();
    return;
  }

  if (trigger.dataset.resetArchive !== undefined) {
    state.archiveFilters = { keyword: '', status: '', gender: '' };
    render();
  }
}

async function handleSubmit(event) {
  event.preventDefault();
  const formId = event.target.id;

  if (formId === 'auth-form') {
    await submitAuth();
    return;
  }

  if (formId === 'archive-search-form') {
    render();
    return;
  }

  if (formId === 'adoption-form') {
    await submitAdoption();
    return;
  }

  if (formId === 'rescue-form') {
    await submitRescue();
    return;
  }

  if (formId === 'dynamic-form') {
    await submitDynamic();
    return;
  }

  if (formId === 'donation-form') {
    await submitDonation();
    return;
  }

  if (formId === 'profile-form') {
    await submitProfile();
    return;
  }

  if (formId === 'verification-form') {
    await submitVerification();
    return;
  }

  if (formId === 'material-form') {
    await submitMaterialAppointment();
    return;
  }

  if (formId.startsWith('comment-form-')) {
    const id = Number(formId.replace('comment-form-', ''));
    await submitComment(id);
  }
}

function handleInput(event) {
  const target = event.target;
  switch (target.id) {
    case 'archive-keyword':
      state.archiveFilters.keyword = target.value;
      break;
    case 'adoption-reason':
      state.adoptionForm.reason = target.value;
      break;
    case 'adoption-living':
      state.adoptionForm.livingCondition = target.value;
      break;
    case 'adoption-experience':
      state.adoptionForm.experience = target.value;
      break;
    case 'adoption-phone':
      state.adoptionForm.contactPhone = target.value;
      break;
    case 'adoption-address':
      state.adoptionForm.contactAddress = target.value;
      break;
    case 'rescue-title':
      state.rescueForm.title = target.value;
      break;
    case 'rescue-description':
      state.rescueForm.description = target.value;
      break;
    case 'rescue-location':
      state.rescueForm.location = target.value;
      break;
    case 'rescue-phone':
      state.rescueForm.contactPhone = target.value;
      break;
    case 'rescue-image':
      state.rescueForm.imagePath = target.value;
      break;
    case 'dynamic-content':
      state.dynamicForm.content = target.value;
      break;
    case 'dynamic-location':
      state.dynamicForm.location = target.value;
      break;
    case 'dynamic-image':
      state.dynamicForm.imagePath = target.value;
      break;
    case 'donation-amount':
      state.donationForm.amount = target.value;
      break;
    case 'donation-message':
      state.donationForm.message = target.value;
      break;
    case 'profile-realname':
      state.profileForm.realName = target.value;
      break;
    case 'profile-studentid':
      state.profileForm.studentId = target.value;
      break;
    case 'profile-phone':
      state.profileForm.phone = target.value;
      break;
    case 'profile-email':
      state.profileForm.email = target.value;
      break;
    case 'profile-college':
      state.profileForm.college = target.value;
      break;
    case 'profile-introduction':
      state.profileForm.introduction = target.value;
      break;
    case 'verification-realname':
      state.verificationForm.realName = target.value;
      break;
    case 'verification-department':
      state.verificationForm.department = target.value;
      break;
    case 'verification-studentid':
      state.verificationForm.studentId = target.value;
      break;
    case 'verification-idcard':
      state.verificationForm.idCard = target.value;
      break;
    case 'auth-username':
      state.authForm.username = target.value;
      break;
    case 'auth-password':
      state.authForm.password = target.value;
      break;
    case 'auth-realname':
      state.authForm.realName = target.value;
      break;
    case 'auth-phone':
      state.authForm.phone = target.value;
      break;
    case 'auth-email':
      state.authForm.email = target.value;
      break;
    case 'material-name':
      state.materialForm.contactName = target.value;
      break;
    case 'material-phone':
      state.materialForm.contactPhone = target.value;
      break;
    case 'material-quantity':
      state.materialForm.quantity = target.value;
      break;
    case 'material-point':
      state.materialForm.pickupPoint = target.value;
      break;
    case 'material-note':
      state.materialForm.note = target.value;
      break;
    default:
      if (target.dataset.commentId) {
        state.commentDrafts[target.dataset.commentId] = target.value;
      }
  }
}

async function handleChange(event) {
  const target = event.target;
  switch (target.id) {
    case 'archive-status':
      state.archiveFilters.status = target.value;
      render();
      break;
    case 'archive-gender':
      state.archiveFilters.gender = target.value;
      render();
      break;
    case 'rescue-topic':
      state.rescueForm.topic = target.value;
      break;
    case 'rescue-priority':
      state.rescueForm.priority = Number(target.value);
      break;
    case 'rescue-needs-vet':
      state.rescueForm.needsVet = target.checked;
      break;
    case 'dynamic-type':
      state.dynamicForm.type = target.value;
      break;
    case 'donation-project':
      state.donationForm.crowdfundingId = target.value;
      render();
      break;
    case 'donation-method':
      state.donationForm.paymentMethod = target.value;
      break;
    case 'donation-anonymous':
      state.donationForm.isAnonymous = target.checked;
      break;
    case 'material-type':
      state.materialForm.itemType = target.value;
      break;
    case 'profile-gender':
      state.profileForm.gender = target.value;
      break;
    case 'verification-university':
      state.verificationForm.universityId = target.value;
      break;
    case 'verification-type':
      state.verificationForm.verificationType = target.value;
      break;
    case 'rescue-image-file':
      await uploadImageForField(target, 'rescue-image', (path) => {
        state.rescueForm.imagePath = path;
      });
      break;
    case 'verification-id-front-file':
      await uploadImageForField(target, 'verification-id-front', (path) => {
        state.verificationForm.idCardFront = path;
      });
      break;
    case 'verification-id-back-file':
      await uploadImageForField(target, 'verification-id-back', (path) => {
        state.verificationForm.idCardBack = path;
      });
      break;
    case 'verification-student-card-file':
      await uploadImageForField(target, 'verification-student-card', (path) => {
        state.verificationForm.studentCard = path;
      });
      break;
  }
}

async function submitAuth() {
  try {
    if (state.authMode === 'login') {
      const data = await login(state.authForm.username, state.authForm.password);
      setAuth(data.token, data.user);
      await loadPublicData();
      await loadUserData();
      state.authModalOpen = false;
      render();
      showToast('登录成功', 'success');
      return;
    }

    await api('/users/register', {
      auth: false,
      method: 'POST',
      body: {
        username: state.authForm.username,
        password: state.authForm.password,
        realName: state.authForm.realName,
        phone: state.authForm.phone,
        email: state.authForm.email
      }
    });
    state.authMode = 'login';
    render();
    showToast('注册成功，请直接登录', 'success');
  } catch (error) {
    showToast(error.message || '认证失败', 'error');
  }
}

async function submitAdoption() {
  const animal = getSelectedAnimal();
  if (!requireLogin()) return;
  if (!animal) {
    showToast('请先选择要领养的动物', 'warning');
    return;
  }

  try {
    await api('/adoption-applications', {
      method: 'POST',
      body: {
        catId: animal.id,
        reason: state.adoptionForm.reason,
        livingCondition: state.adoptionForm.livingCondition,
        experience: state.adoptionForm.experience,
        contactPhone: state.adoptionForm.contactPhone,
        contactAddress: state.adoptionForm.contactAddress
      }
    });
    resetAdoptionForm();
    await loadUserData();
    render();
    showToast('领养申请已提交', 'success');
  } catch (error) {
    state.verificationRequired = error.message.includes('身份认证');
    render();
    showToast(error.message || '领养申请提交失败', 'error');
  }
}

async function submitRescue() {
  if (!requireLogin()) return;

  try {
    await api('/rescue-info', {
      method: 'POST',
      body: {
        title: state.rescueForm.title,
        type: mapRescueTopicToType(state.rescueForm.topic),
        description: buildRescueDescription(state.rescueForm),
        images: compactArray([state.rescueForm.imagePath]),
        location: state.rescueForm.location,
        contactPhone: state.rescueForm.contactPhone,
        priority: state.rescueForm.priority
      }
    });
    state.rescueForm = {
      title: '',
      topic: 'INJURED',
      description: '',
      location: '',
      contactPhone: state.user?.phone || '',
      priority: 1,
      imagePath: '',
      needsVet: true
    };
    await loadUserData();
    render();
    showToast('救助信息已发布', 'success');
  } catch (error) {
    showToast(error.message || '救助信息发布失败', 'error');
  }
}

async function submitDynamic() {
  if (!requireLogin()) return;

  try {
    await api('/dynamics', {
      method: 'POST',
      body: {
        content: state.dynamicForm.content,
        images: compactArray([state.dynamicForm.imagePath]),
        location: state.dynamicForm.location,
        type: state.dynamicForm.type
      }
    });
    state.dynamicForm = {
      content: '',
      type: 'UPDATE',
      location: '',
      imagePath: ''
    };
    await refreshDynamics();
    render();
    showToast('动态已发布', 'success');
  } catch (error) {
    showToast(error.message || '动态发布失败', 'error');
  }
}

async function submitDonation() {
  if (!requireLogin()) return;

  try {
    await api('/donation', {
      method: 'POST',
      body: {
        crowdfundingId: Number(state.donationForm.crowdfundingId),
        amount: Number(state.donationForm.amount),
        message: state.donationForm.message,
        isAnonymous: state.donationForm.isAnonymous,
        paymentMethod: state.donationForm.paymentMethod
      }
    });
    state.donationForm.message = '';
    await loadUserData();
    render();
    showToast('支持已提交，感谢你的善意', 'success');
  } catch (error) {
    showToast(error.message || '提交支持失败', 'error');
  }
}

async function submitProfile() {
  if (!requireLogin()) return;

  try {
    await api('/users/profile', {
      method: 'PUT',
      body: {
        username: state.profileForm.username,
        realName: state.profileForm.realName,
        studentId: state.profileForm.studentId,
        phone: state.profileForm.phone,
        email: state.profileForm.email,
        gender: emptyToNull(state.profileForm.gender),
        college: state.profileForm.college,
        introduction: state.profileForm.introduction
      }
    });
    await loadUserData();
    render();
    showToast('个人信息已更新', 'success');
  } catch (error) {
    showToast(error.message || '保存失败', 'error');
  }
}

async function submitVerification() {
  if (!requireLogin()) return;

  const payload = {
    universityId: Number(state.verificationForm.universityId || state.universities[0]?.id || 1),
    realName: state.verificationForm.realName.trim(),
    studentId: state.verificationForm.studentId.trim(),
    department: state.verificationForm.department.trim(),
    idCard: state.verificationForm.idCard.trim(),
    idCardFront: state.verificationForm.idCardFront,
    idCardBack: state.verificationForm.idCardBack,
    studentCard: state.verificationForm.studentCard,
    verificationType: state.verificationForm.verificationType
  };

  if (!payload.realName || !payload.studentId || !payload.department || !payload.idCard) {
    showToast('请先填写完整的认证信息', 'warning');
    return;
  }

  if (!payload.idCardFront || !payload.idCardBack || !payload.studentCard) {
    showToast('请上传身份证正反面和学生证 / 工作证图片', 'warning');
    return;
  }

  try {
    const exists = await api('/verification/check-student-id', {
      query: {
        studentId: payload.studentId,
        universityId: payload.universityId
      }
    });

    if (exists && payload.studentId !== state.verificationRecord?.studentId) {
      showToast('该学号 / 工号已被认证，请检查后重试', 'error');
      return;
    }

    if (state.verificationRecord?.id && state.verificationRecord?.status === 'REJECTED') {
      await api(`/verification/${state.verificationRecord.id}/resubmit`, {
        method: 'PUT',
        body: payload
      });
      showToast('认证申请已重新提交', 'success');
    } else {
      await api('/verification', {
        method: 'POST',
        body: payload
      });
      showToast('认证申请已提交', 'success');
    }

    await loadUserData();
    render();
  } catch (error) {
    showToast(error.message || '认证提交失败', 'error');
  }
}

async function withdrawVerification() {
  if (!requireLogin()) return;
  if (!state.verificationRecord?.id) {
    showToast('当前没有可撤回的认证申请', 'warning');
    return;
  }

  try {
    await api(`/verification/${state.verificationRecord.id}`, { method: 'DELETE' });
    await loadUserData();
    render();
    showToast('认证申请已撤回', 'success');
  } catch (error) {
    showToast(error.message || '撤回失败', 'error');
  }
}

async function submitMaterialAppointment() {
  if (!requireLogin()) return;

  const payload = {
    ...state.materialForm,
    contactName: state.materialForm.contactName.trim(),
    contactPhone: state.materialForm.contactPhone.trim(),
    quantity: state.materialForm.quantity.trim(),
    pickupPoint: state.materialForm.pickupPoint.trim(),
    note: state.materialForm.note.trim(),
    itemTypeText: materialTypeText(state.materialForm.itemType),
    createdAt: new Date().toISOString(),
    syncStatus: '待联系确认'
  };

  if (!payload.contactName || !payload.contactPhone || !payload.quantity || !payload.pickupPoint) {
    showToast('请完整填写实物捐赠预约信息', 'warning');
    return;
  }

  try {
    await api('/rescue-info', {
      method: 'POST',
      body: {
        title: `实物捐赠预约 · ${payload.itemTypeText}`,
        type: 'MATERIAL',
        description: [
          `【预约人】${payload.contactName}`,
          `【物资数量】${payload.quantity}`,
          payload.note ? `【备注】${payload.note}` : '',
          '【处理方式】请志愿者对接收货并在线下核销后完成闭环确认'
        ].filter(Boolean).join('\n'),
        images: [],
        location: payload.pickupPoint,
        contactPhone: payload.contactPhone,
        priority: 0
      }
    });

    state.materialAppointments = [payload, ...state.materialAppointments].slice(0, 8);
    writeJSON(STORAGE_KEYS.materials, state.materialAppointments);
    state.materialForm = {
      contactName: displayName(state.user),
      contactPhone: state.user?.phone || '',
      itemType: 'CAT_FOOD',
      quantity: '',
      pickupPoint: '公益社团办公室',
      note: ''
    };
    await loadUserData();
    render();
    showToast('实物捐赠预约已登记，请等待工作人员联系', 'success');
  } catch (error) {
    showToast(error.message || '实物捐赠预约失败', 'error');
  }
}

async function uploadImageForField(input, fieldKey, applyPath) {
  const file = input.files && input.files[0];
  if (!file) return;

  state.uploadingField = fieldKey;
  render();

  try {
    const path = await uploadFile(file, 'image');
    applyPath(path);
    showToast('图片上传成功', 'success');
  } catch (error) {
    showToast(error.message || '图片上传失败', 'error');
  } finally {
    state.uploadingField = '';
    render();
  }
}

async function uploadFile(file, type) {
  const form = new FormData();
  form.append('file', file);

  const headers = {};
  if (state.token) {
    headers.Authorization = `Bearer ${state.token}`;
  }

  const response = await fetch(`${API_BASE}/files/upload/${type}`, {
    method: 'POST',
    headers,
    body: form
  });

  const payload = normalizePayload(await response.json().catch(() => {
    throw new Error('上传接口返回了无法解析的数据');
  }));

  if (payload.code !== 200) {
    throw new Error(payload.message || '上传失败');
  }

  return resolveUploadedPath(payload.data);
}

function resolveUploadedPath(data) {
  const path = data?.filePath || data?.path || data?.url || data?.relativePath || data?.accessUrl;
  if (!path) {
    throw new Error('上传成功但接口没有返回文件路径');
  }
  return String(path);
}

async function submitComment(dynamicId) {
  if (!requireLogin()) return;

  try {
    await api('/comments', {
      method: 'POST',
      body: {
        dynamicId,
        content: state.commentDrafts[dynamicId] || ''
      }
    });
    state.commentDrafts[dynamicId] = '';
    await loadComments(dynamicId, true);
    showToast('评论已发布', 'success');
  } catch (error) {
    showToast(error.message || '评论失败', 'error');
  }
}

async function likeDynamic(dynamicId) {
  if (!requireLogin()) return;

  try {
    await api(`/dynamics/${dynamicId}/like`, { method: 'POST' });
    await refreshDynamics();
    render();
  } catch (error) {
    showToast(error.message || '点赞失败', 'error');
  }
}

async function loadComments(dynamicId, rerender = false) {
  try {
    const data = await api(`/comments/dynamic/${dynamicId}`, {
      auth: false,
      query: { current: 1, size: 20, dynamicId }
    });
    state.comments[dynamicId] = Array.isArray(data) ? data : pageRecords(data);
    if (rerender) render();
    else render();
  } catch (error) {
    showToast(error.message || '评论加载失败', 'error');
  }
}

async function respondRescue(rescueId) {
  if (!requireLogin()) return;
  state.rescueBusyId = rescueId;
  render();
  try {
    await api(`/rescue-info/${rescueId}/respond`, { method: 'POST' });
    await loadUserData();
    render();
    showToast('已报名参与救助', 'success');
  } catch (error) {
    state.rescueBusyId = null;
    render();
    showToast(error.message || '报名失败', 'error');
  }
}

async function closeRescue(rescueId) {
  if (!requireLogin()) return;
  state.rescueBusyId = rescueId;
  render();
  try {
    await api(`/rescue-info/${rescueId}/close`, {
      method: 'PUT',
      query: { resolveNote: '前台确认已完成' }
    });
    await loadUserData();
    render();
    showToast('已确认救助完成', 'success');
  } catch (error) {
    state.rescueBusyId = null;
    render();
    showToast(error.message || '完成确认失败', 'error');
  }
}

async function refreshDynamics() {
  try {
    const data = await api('/dynamics/page', { auth: false, query: { current: 1, size: 12 } });
    state.dynamics = pageRecords(data);
  } catch (error) {
    showToast(error.message || '动态刷新失败', 'error');
  }
}

async function login(username, password) {
  const form = new URLSearchParams();
  form.set('username', username);
  form.set('password', password);

  const response = await fetch(`${API_BASE}/users/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: form.toString()
  });
  const payload = await response.json();
  if (payload.code !== 200) {
    throw new Error(payload.message || '登录失败');
  }
  return payload.data;
}

async function api(path, options = {}) {
  const {
    method = 'GET',
    query,
    body,
    auth = true
  } = options;

  const url = new URL(`${API_BASE}${path}`, window.location.origin);
  if (query) {
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        url.searchParams.set(key, value);
      }
    });
  }

  const headers = {};
  let requestBody;

  if (auth && state.token) {
    headers.Authorization = `Bearer ${state.token}`;
  }

  if (body !== undefined) {
    headers['Content-Type'] = 'application/json';
    requestBody = JSON.stringify(body);
  }

  const response = await fetch(url.toString(), {
    method,
    headers,
    body: requestBody
  });

  const payload = normalizePayload(await response.json().catch(() => {
    throw new Error('接口返回了无法解析的数据');
  }));

  if (payload.code !== 200) {
    throw new Error(payload.message || '请求失败');
  }

  return payload.data;
}

function filteredAnimals() {
  return state.cats.filter((item) => {
    const keyword = state.archiveFilters.keyword.trim().toLowerCase();
    const matchedKeyword = keyword
      ? [item.name, item.breed, item.rescueLocation, item.description, item.character]
          .filter(Boolean)
          .join(' ')
          .toLowerCase()
          .includes(keyword)
      : true;
    const matchedStatus = state.archiveFilters.status ? item.status === state.archiveFilters.status : true;
    const matchedGender = state.archiveFilters.gender ? String(item.gender) === String(state.archiveFilters.gender) : true;
    return matchedKeyword && matchedStatus && matchedGender;
  });
}

function filteredDynamics() {
  if (state.communityFilter === 'memorial') {
    return [];
  }

  return state.dynamics.filter((item) => {
    if (state.communityFilter === 'science') {
      return /科普|疫苗|绝育|护理|救助|治疗/.test(item.content || '');
    }
    if (state.communityFilter === 'daily') {
      return true;
    }
    return true;
  });
}

function getSelectedAnimal() {
  return state.cats.find((item) => item.id === state.selectedAnimalId) || state.cats[0] || null;
}

function isFavorite(id) {
  return state.favorites.includes(id);
}

function toggleFavorite(id) {
  if (isFavorite(id)) {
    state.favorites = state.favorites.filter((item) => item !== id);
    showToast('已取消收藏', 'info');
  } else {
    state.favorites = [id, ...state.favorites].slice(0, 12);
    showToast('已加入收藏', 'success');
  }
  writeJSON(STORAGE_KEYS.favorites, state.favorites);
}

function rememberHistory(id) {
  state.history = [id, ...state.history.filter((item) => item !== id)].slice(0, 12);
  writeJSON(STORAGE_KEYS.history, state.history);
}

function requireLogin() {
  if (state.user) return true;
  state.authMode = 'login';
  state.authModalOpen = true;
  render();
  showToast('请先登录', 'warning');
  return false;
}

function setAuth(token, user) {
  const normalizedUser = normalizePayload(user);
  state.token = token;
  state.user = normalizedUser;
  document.cookie = `${STORAGE_KEYS.token}=${encodeURIComponent(token)}; path=/; max-age=604800`;
  localStorage.setItem(STORAGE_KEYS.token, token);
  writeJSON(STORAGE_KEYS.user, normalizedUser);
}

function clearAuth() {
  state.token = '';
  state.user = null;
  state.verified = false;
  state.verificationStatus = 'UNSUBMITTED';
  state.verificationRecord = null;
  state.applications = [];
  state.donations = [];
  state.rescues = [];
  state.rescueLocked = true;
  localStorage.removeItem(STORAGE_KEYS.token);
  localStorage.removeItem(STORAGE_KEYS.user);
  document.cookie = `${STORAGE_KEYS.token}=; path=/; max-age=0`;
}

function resetAdoptionForm() {
  state.adoptionForm = {
    reason: '',
    livingCondition: '',
    experience: '',
    contactPhone: state.user?.phone || '',
    contactAddress: ''
  };
}

function unwrapSettled(result, fallback) {
  return result.status === 'fulfilled' ? result.value : fallback;
}

function pageRecords(payload) {
  if (!payload) return [];
  if (Array.isArray(payload)) return payload;
  if (Array.isArray(payload.records)) return payload.records;
  if (Array.isArray(payload.list)) return payload.list;
  return [];
}

function filterTimestampedRecords(records) {
  return (records || []).filter((item) => item && (item.createTime || item.updateTime || item.formattedTime));
}

function displayName(user) {
  return user?.realName || user?.username || '访客';
}

function syncVerificationForm(profile, record) {
  Object.assign(state.verificationForm, {
    universityId: String(record?.universityId || state.verificationForm.universityId || state.universities[0]?.id || 1),
    realName: record?.realName || profile.realName || '',
    studentId: record?.studentId || profile.studentId || '',
    department: record?.department || profile.college || '',
    idCard: record?.idCard || '',
    verificationType: record?.verificationType || state.verificationForm.verificationType || 'STUDENT',
    idCardFront: record?.idCardFront || '',
    idCardBack: record?.idCardBack || '',
    studentCard: record?.studentCard || ''
  });

  if (!state.materialForm.contactName) {
    state.materialForm.contactName = displayName(profile);
  }
  if (!state.materialForm.contactPhone) {
    state.materialForm.contactPhone = profile.phone || '';
  }
}

function maskIdCard(value) {
  const raw = String(value || '').trim();
  if (!raw) return '待填写';
  if (raw.length < 8) return raw;
  return `${raw.slice(0, 4)}********${raw.slice(-4)}`;
}

function genderText(value) {
  return String(value) === '1' ? '公' : String(value) === '0' ? '母' : '未知';
}

function truthText(value) {
  return Number(value) === 1 ? '已完成' : Number(value) === 0 ? '待补充' : '待补充';
}

function priorityText(value) {
  return Number(value) === 2 ? '特急' : Number(value) === 1 ? '紧急' : '普通';
}

function verificationStatusText(status) {
  return {
    APPROVED: '认证已通过',
    PENDING: '等待审核',
    REJECTED: '审核未通过',
    WITHDRAWN: '已撤回',
    UNSUBMITTED: '未提交'
  }[status] || status || '未提交';
}

function verificationTypeText(type) {
  return {
    STUDENT: '学生认证',
    STAFF: '教职工认证',
    VOLUNTEER: '志愿者认证'
  }[type] || type || '学生认证';
}

function toneForVerification(status) {
  return {
    APPROVED: 'success',
    PENDING: 'warning',
    REJECTED: 'danger',
    WITHDRAWN: 'neutral',
    UNSUBMITTED: 'neutral'
  }[status] || 'neutral';
}

function mapRescueTopicToType(topic) {
  return {
    LOST: 'LOST',
    MATERIAL: 'MATERIAL',
    EMERGENCY: 'EMERGENCY',
    DISEASE: 'INJURED',
    STERILIZATION: 'INJURED',
    INJURED: 'INJURED'
  }[topic] || 'INJURED';
}

function rescueTopicText(topic) {
  return {
    LOST: '走失寻找',
    MATERIAL: '物资求助',
    EMERGENCY: '特急处理',
    DISEASE: '疾病医疗',
    STERILIZATION: '绝育支持',
    INJURED: '受伤救助'
  }[topic] || '受伤救助';
}

function buildRescueDescription(form) {
  return [
    `【救助主题】${rescueTopicText(form.topic)}`,
    `【公益兽医】${form.needsVet ? '需要介入' : '常规跟进'}`,
    form.description.trim()
  ].filter(Boolean).join('\n');
}

function toneForAnimal(status) {
  return {
    ADOPTABLE: 'success',
    ADOPTED: 'neutral',
    OBSERVATION: 'warning',
    TREATMENT: 'danger'
  }[status] || 'neutral';
}

function toneForStatus(status) {
  return {
    PENDING: 'warning',
    PROCESSING: 'accent',
    APPROVED: 'success',
    REJECTED: 'danger',
    WITHDRAWN: 'neutral'
  }[status] || 'neutral';
}

function toneForRescue(type) {
  return {
    INJURED: 'danger',
    LOST: 'warning',
    MATERIAL: 'accent',
    EMERGENCY: 'danger'
  }[type] || 'neutral';
}

function toneForPriority(priority) {
  return Number(priority) >= 2 ? 'danger' : Number(priority) === 1 ? 'warning' : 'neutral';
}

function dynamicLabel(item) {
  if (item.type === 'FEED') return '动物日常';
  if (item.type === 'PHOTO') return '社区照片';
  return '进展更新';
}

function materialTypeText(value) {
  return {
    CAT_FOOD: '猫粮',
    DOG_FOOD: '狗粮',
    CAT_LITTER: '猫砂',
    MEDICINE: '药品',
    SUPPLIES: '用品'
  }[value] || '物资';
}

function normalizeMaterialSyncStatus(value) {
  if (!value) return '待联系确认';
  if (value === '已同步到救助中心') return '待联系确认';
  return value;
}

function formatDate(value) {
  if (!value) return '待补充';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return String(value).slice(0, 10);
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`;
}

function pad(value) {
  return String(value).padStart(2, '0');
}

function currency(value) {
  return new Intl.NumberFormat('zh-CN', {
    style: 'currency',
    currency: 'CNY',
    maximumFractionDigits: 0
  }).format(Number(value || 0));
}

function imageUrl(path) {
  if (!path) return '/uploads/cats/cat1.jpg';
  return path.startsWith('/') ? path : `/${path}`;
}

function normalizeImageList(images) {
  if (Array.isArray(images)) return images;
  if (typeof images === 'string') {
    try {
      const parsed = JSON.parse(images);
      return Array.isArray(parsed) ? parsed : [images];
    } catch {
      return images ? [images] : [];
    }
  }
  return [];
}

function publicImageList(images) {
  return normalizeImageList(images)
    .map((item) => imageUrl(item))
    .filter((item) => !/^\/uploads\/(rescue|dynamic)\//.test(item));
}

function uniqueStrings(list) {
  return [...new Set(list.filter(Boolean))];
}

function compactArray(list) {
  return list.map((item) => String(item || '').trim()).filter(Boolean);
}

function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function escapeAttr(value) {
  return escapeHtml(value);
}

function emptyToNull(value) {
  return value === '' ? null : value;
}

function normalizePayload(value) {
  if (Array.isArray(value)) {
    return value.map(normalizePayload);
  }

  if (value && typeof value === 'object') {
    return Object.fromEntries(
      Object.entries(value).map(([key, entry]) => [key, normalizePayload(entry)])
    );
  }

  if (typeof value === 'string') {
    return normalizeString(value);
  }

  return value;
}

function normalizeString(value) {
  if (!looksLikeMojibake(value)) return value;

  try {
    const bytes = [];
    for (const char of value) {
      const code = char.charCodeAt(0);
      if (code <= 255) {
        bytes.push(code);
        continue;
      }

      const mapped = WINDOWS_1252_EXTENDED[char];
      if (mapped === undefined) {
        return value;
      }
      bytes.push(mapped);
    }

    const decoded = new TextDecoder('utf-8', { fatal: false }).decode(Uint8Array.from(bytes));
    return /[\u4e00-\u9fff]/.test(decoded) ? decoded : value;
  } catch {
    return value;
  }
}

function looksLikeMojibake(value) {
  if (/[\u4e00-\u9fff]/.test(value)) return false;
  const matches = value.match(/[À-ÿ€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ]/g);
  return Boolean(matches && matches.length >= 2);
}

function readJSON(key, fallback) {
  try {
    const raw = localStorage.getItem(key);
    return raw ? normalizePayload(JSON.parse(raw)) : fallback;
  } catch {
    return fallback;
  }
}

function writeJSON(key, value) {
  localStorage.setItem(key, JSON.stringify(value));
}

function readToken() {
  return localStorage.getItem(STORAGE_KEYS.token) || readCookie(STORAGE_KEYS.token) || '';
}

function readCookie(name) {
  const prefix = `${name}=`;
  return document.cookie
    .split(';')
    .map((item) => item.trim())
    .find((item) => item.startsWith(prefix))
    ?.slice(prefix.length) || '';
}

function showToast(message, type = 'info') {
  const id = `${Date.now()}-${Math.random().toString(16).slice(2)}`;
  const host = document.getElementById('toast-host');
  state.loading = false;

  if (!host) return;

  const node = document.createElement('div');
  node.className = `toast ${type}`;
  node.textContent = message;
  node.dataset.toastId = id;
  host.appendChild(node);

  setTimeout(() => {
    node.classList.add('is-leaving');
    setTimeout(() => node.remove(), 220);
  }, 2600);
}

function flushToasts() {
  const host = document.getElementById('toast-host');
  if (!host) return;
}

const WINDOWS_1252_EXTENDED = {
  '€': 128,
  '‚': 130,
  'ƒ': 131,
  '„': 132,
  '…': 133,
  '†': 134,
  '‡': 135,
  'ˆ': 136,
  '‰': 137,
  'Š': 138,
  '‹': 139,
  'Œ': 140,
  'Ž': 142,
  '‘': 145,
  '’': 146,
  '“': 147,
  '”': 148,
  '•': 149,
  '–': 150,
  '—': 151,
  '˜': 152,
  '™': 153,
  'š': 154,
  '›': 155,
  'œ': 156,
  'ž': 158,
  'Ÿ': 159
};
