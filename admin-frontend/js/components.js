// Reusable UI Components

// ==================== Table Component ====================
const TableComponent = {
    // Render table
    render(container, options) {
        const {
            columns = [],
            data = [],
            actions = [],
            emptyText = '暂无数据'
        } = options;

        if (data.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <div class="empty-state-text">${emptyText}</div>
                </div>
            `;
            return;
        }

        let html = '<table class="data-table"><thead><tr>';

        // Render headers
        columns.forEach(col => {
            html += `<th>${col.label}</th>`;
        });

        if (actions.length > 0) {
            html += '<th>操作</th>';
        }

        html += '</tr></thead><tbody>';

        // Render rows
        data.forEach(row => {
            html += '<tr>';

            columns.forEach(col => {
                let value = row[col.field];

                // Apply formatter if provided
                if (col.formatter) {
                    value = col.formatter(value, row);
                }

                html += `<td>${value !== null && value !== undefined ? value : '-'}</td>`;
            });

            // Render actions
            if (actions.length > 0) {
                html += '<td>';
                actions.forEach(action => {
                    if (!action.show || action.show(row)) {
                        html += `<button class="btn btn-sm ${action.type || 'btn-default'}"
                                        data-action="${action.name}"
                                        data-id="${row.id || row[col.field]}"
                                        style="margin-right: 8px;">
                                    ${action.label}
                                </button>`;
                    }
                });
                html += '</td>';
            }

            html += '</tr>';
        });

        html += '</tbody></table>';
        container.innerHTML = html;

        // Bind action handlers
        if (actions.length > 0) {
            container.querySelectorAll('[data-action]').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const actionName = e.target.getAttribute('data-action');
                    const id = e.target.getAttribute('data-id');
                    const action = actions.find(a => a.name === actionName);
                    if (action && action.handler) {
                        action.handler(id, row);
                    }
                });
            });
        }
    }
};

// ==================== Pagination Component ====================
const PaginationComponent = {
    // Render pagination
    render(container, options) {
        const {
            current = 1,
            total = 0,
            pageSize = 10,
            onChange = () => {}
        } = options;

        const totalPages = Math.ceil(total / pageSize);

        if (totalPages <= 1) {
            container.innerHTML = '';
            return;
        }

        let html = '<div class="pagination">';

        // Previous button
        html += `<button class="pagination-btn" data-page="${current - 1}" ${current === 1 ? 'disabled' : ''}>上一页</button>`;

        // Page numbers
        const startPage = Math.max(1, current - 2);
        const endPage = Math.min(totalPages, current + 2);

        if (startPage > 1) {
            html += `<button class="pagination-btn" data-page="1">1</button>`;
            if (startPage > 2) {
                html += '<span style="padding: 0 8px;">...</span>';
            }
        }

        for (let i = startPage; i <= endPage; i++) {
            html += `<button class="pagination-btn ${i === current ? 'active' : ''}" data-page="${i}">${i}</button>`;
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                html += '<span style="padding: 0 8px;">...</span>';
            }
            html += `<button class="pagination-btn" data-page="${totalPages}">${totalPages}</button>`;
        }

        // Next button
        html += `<button class="pagination-btn" data-page="${current + 1}" ${current === totalPages ? 'disabled' : ''}>下一页</button>`;

        html += '</div>';

        container.innerHTML = html;

        // Bind click handlers
        container.querySelectorAll('[data-page]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                if (!e.target.disabled) {
                    const page = parseInt(e.target.getAttribute('data-page'));
                    onChange(page);
                }
            });
        });
    }
};

// ==================== Form Component ====================
const FormComponent = {
    // Render form
    render(container, options) {
        const {
            fields = [],
            data = {},
            onSubmit = () => {}
        } = options;

        let html = '<form class="admin-form">';

        fields.forEach(field => {
            html += '<div class="form-group">';
            html += `<label class="form-label">${field.label}${field.required ? '<span style="color: var(--danger);">*</span>' : ''}</label>`;

            const value = data[field.name] || field.defaultValue || '';

            switch (field.type) {
                case 'text':
                case 'email':
                case 'number':
                case 'password':
                    html += `<input type="${field.type}"
                                   class="form-input"
                                   name="${field.name}"
                                   value="${value}"
                                   placeholder="${field.placeholder || ''}"
                                   ${field.required ? 'required' : ''}
                                   ${field.disabled ? 'disabled' : ''}>`;
                    break;

                case 'textarea':
                    html += `<textarea class="form-textarea"
                                      name="${field.name}"
                                      placeholder="${field.placeholder || ''}"
                                      ${field.required ? 'required' : ''}
                                      ${field.disabled ? 'disabled' : ''}>${value}</textarea>`;
                    break;

                case 'select':
                    html += `<select class="form-select"
                                    name="${field.name}"
                                    ${field.required ? 'required' : ''}
                                    ${field.disabled ? 'disabled' : ''}>`;
                    if (field.placeholder) {
                        html += `<option value="">${field.placeholder}</option>`;
                    }
                    field.options.forEach(opt => {
                        const selected = value === opt.value ? 'selected' : '';
                        html += `<option value="${opt.value}" ${selected}>${opt.label}</option>`;
                    });
                    html += '</select>';
                    break;

                case 'date':
                    html += `<input type="date"
                                   class="form-input"
                                   name="${field.name}"
                                   value="${value}"
                                   ${field.required ? 'required' : ''}
                                   ${field.disabled ? 'disabled' : ''}>`;
                    break;
            }

            if (field.help) {
                html += `<div class="form-help">${field.help}</div>`;
            }

            html += '</div>';
        });

        html += '</form>';

        container.innerHTML = html;

        // Get form element
        const form = container.querySelector('.admin-form');

        // Return form data getter
        return {
            getData() {
                const formData = new FormData(form);
                const data = {};
                for (let [key, value] of formData.entries()) {
                    data[key] = value;
                }
                return data;
            },
            validate() {
                return form.checkValidity();
            },
            reset() {
                form.reset();
            }
        };
    }
};

// ==================== Filter Component ====================
const FilterComponent = {
    // Render filters
    render(container, options) {
        const {
            filters = [],
            onFilter = () => {}
        } = options;

        let html = '<div class="filter-bar" style="display: flex; gap: 12px; margin-bottom: 16px; flex-wrap: wrap;">';

        filters.forEach(filter => {
            switch (filter.type) {
                case 'search':
                    html += `<input type="text"
                                   class="form-input"
                                   name="${filter.name}"
                                   placeholder="${filter.placeholder || '搜索...'}"
                                   style="width: 200px;">`;
                    break;

                case 'select':
                    html += `<select class="form-select" name="${filter.name}" style="width: 150px;">`;
                    html += `<option value="">${filter.placeholder || '全部'}</option>`;
                    filter.options.forEach(opt => {
                        html += `<option value="${opt.value}">${opt.label}</option>`;
                    });
                    html += '</select>';
                    break;

                case 'date':
                    html += `<input type="date" class="form-input" name="${filter.name}" style="width: 150px;">`;
                    break;
            }
        });

        html += '<button class="btn btn-primary" id="filterBtn">筛选</button>';
        html += '<button class="btn btn-default" id="resetBtn">重置</button>';
        html += '</div>';

        container.innerHTML = html;

        // Get filter data
        const getFilterData = () => {
            const data = {};
            filters.forEach(filter => {
                const input = container.querySelector(`[name="${filter.name}"]`);
                if (input && input.value) {
                    data[filter.name] = input.value;
                }
            });
            return data;
        };

        // Bind filter button
        container.querySelector('#filterBtn').addEventListener('click', () => {
            onFilter(getFilterData());
        });

        // Bind reset button
        container.querySelector('#resetBtn').addEventListener('click', () => {
            filters.forEach(filter => {
                const input = container.querySelector(`[name="${filter.name}"]`);
                if (input) input.value = '';
            });
            onFilter({});
        });

        // Bind enter key for search inputs
        filters.forEach(filter => {
            if (filter.type === 'search') {
                const input = container.querySelector(`[name="${filter.name}"]`);
                if (input) {
                    input.addEventListener('keypress', (e) => {
                        if (e.key === 'Enter') {
                            onFilter(getFilterData());
                        }
                    });
                }
            }
        });
    }
};

// ==================== Stats Card Component ====================
const StatsCardComponent = {
    // Render stats cards
    render(container, stats) {
        let html = '<div class="stats-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 20px;">';

        stats.forEach(stat => {
            html += `
                <div class="stat-card ${stat.color || ''}">
                    <h3>${stat.title}</h3>
                    <div class="value">${stat.value}</div>
                    ${stat.label ? `<div class="label">${stat.label}</div>` : ''}
                </div>
            `;
        });

        html += '</div>';
        container.innerHTML = html;
    }
};
