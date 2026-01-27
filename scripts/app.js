// 团队记忆库 - 数据管理和渲染引擎
// 这个脚本会自动扫描conversations和topics目录，生成动态内容

class MemoryLibrary {
    constructor() {
        this.conversations = [];
        this.topics = [];
        this.stats = {
            conversations: 0,
            topics: 0,
            decisions: 0,
            contributors: new Set()
        };
    }

    // 模拟数据（实际使用时需要从文件系统或API加载）
    async loadData() {
        // 对话记录数据
        this.conversations = [
            {
                file: 'conversations/2026-01/git-shared-memory-design.md',
                date: '2026-01-27',
                author: 'lijun13',
                topic: 'Git共享记忆系统设计',
                tags: ['architecture', 'knowledge-management', 'collaboration', 'claude-code'],
                summary: '基于Git和Claude Code上下文机制，设计团队共享记忆系统。通过结构化存储对话记录和知识，实现团队"集体大脑"效果。',
                status: 'completed'
            },
            {
                file: 'conversations/2026-01/embodied-ai-research.md',
                date: '2026-01-27',
                author: 'lijun13',
                topic: '具身智能企业调研',
                tags: ['research', 'embodied-ai', 'companies', 'industry-analysis'],
                summary: '国内外具身智能领域主要企业调研。涵盖Tesla、Figure AI、宇树科技等企业，分析行业趋势：人形机器人、大模型融合、成本下降等。',
                status: 'completed'
            }
        ];

        // 主题文档数据
        this.topics = {
            'research': {
                name: '🔬 研究调研',
                count: 1,
                items: ['具身智能企业调研']
            },
            'architecture': {
                name: '📐 架构设计',
                count: 1,
                items: ['Git共享记忆系统架构']
            },
            'features': {
                name: '⚙️ 功能实现',
                count: 0,
                items: []
            },
            'debugging': {
                name: '🐛 调试经验',
                count: 0,
                items: []
            }
        };

        // 计算统计数据
        this.conversations.forEach(conv => {
            this.stats.contributors.add(conv.author);
        });
        this.stats.conversations = this.conversations.length;
        this.stats.topics = Object.values(this.topics).reduce((sum, topic) => sum + topic.count, 0);

        return this;
    }

    // 渲染统计卡片
    renderStats() {
        return `
            <div class="stat-card">
                <div class="stat-number">${this.stats.conversations}</div>
                <div class="stat-label">对话记录</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${this.stats.topics}</div>
                <div class="stat-label">主题文档</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${this.stats.decisions}</div>
                <div class="stat-label">架构决策</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${this.stats.contributors.size}</div>
                <div class="stat-label">贡献者</div>
            </div>
        `;
    }

    // 渲染对话卡片
    renderConversationCard(conv) {
        const tags = conv.tags.map(tag => `<span class="tag">${tag}</span>`).join('');
        return `
            <div class="card" data-file="${conv.file}" data-tags="${conv.tags.join(',')}" data-author="${conv.author}">
                <div class="card-header">
                    <div class="card-title">${conv.topic}</div>
                    <div class="card-date">${conv.date}</div>
                </div>
                <div class="card-meta">
                    <div class="card-author">${conv.author}</div>
                    <div style="color: ${conv.status === 'completed' ? '#4caf50' : '#ff9800'}">
                        ${conv.status === 'completed' ? '✓ 已完成' : '🚧 草稿'}
                    </div>
                </div>
                <div class="card-tags">
                    ${tags}
                </div>
                <div class="card-summary">
                    ${conv.summary}
                </div>
            </div>
        `;
    }

    // 渲染所有对话
    renderConversations() {
        return this.conversations
            .sort((a, b) => new Date(b.date) - new Date(a.date))
            .map(conv => this.renderConversationCard(conv))
            .join('');
    }

    // 渲染主题分类
    renderTopics() {
        return Object.entries(this.topics).map(([key, topic]) => {
            const items = topic.items.length > 0
                ? topic.items.map(item => `• ${item}`).join('<br>')
                : '待添加...';

            return `
                <div class="card">
                    <div class="card-title">${topic.name}</div>
                    <div class="card-summary" style="margin-top: 10px;">
                        <strong>${topic.count}篇文档</strong><br>
                        ${items}
                    </div>
                </div>
            `;
        }).join('');
    }

    // 渲染时间线
    renderTimeline() {
        return this.conversations
            .sort((a, b) => new Date(b.date) - new Date(a.date))
            .map(conv => `
                <div class="timeline-item">
                    <div class="card-header">
                        <div class="card-title">${conv.topic}</div>
                        <div class="card-date">${conv.date}</div>
                    </div>
                    <div class="card-meta">
                        <div class="card-author">${conv.author}</div>
                    </div>
                    <div class="card-summary">
                        ${conv.summary}
                    </div>
                </div>
            `).join('');
    }

    // 搜索功能
    search(query) {
        query = query.toLowerCase();
        return this.conversations.filter(conv => {
            return conv.topic.toLowerCase().includes(query) ||
                   conv.summary.toLowerCase().includes(query) ||
                   conv.tags.some(tag => tag.toLowerCase().includes(query)) ||
                   conv.author.toLowerCase().includes(query);
        });
    }

    // 按标签过滤
    filterByTag(tag) {
        return this.conversations.filter(conv => conv.tags.includes(tag));
    }

    // 按作者过滤
    filterByAuthor(author) {
        return this.conversations.filter(conv => conv.author === author);
    }

    // 获取所有标签及其计数
    getAllTags() {
        const tagCount = {};
        this.conversations.forEach(conv => {
            conv.tags.forEach(tag => {
                tagCount[tag] = (tagCount[tag] || 0) + 1;
            });
        });
        return Object.entries(tagCount)
            .sort((a, b) => b[1] - a[1])
            .map(([tag, count]) => ({ tag, count }));
    }

    // 获取贡献者统计
    getContributorStats() {
        const contributorCount = {};
        this.conversations.forEach(conv => {
            contributorCount[conv.author] = (contributorCount[conv.author] || 0) + 1;
        });
        return Object.entries(contributorCount)
            .sort((a, b) => b[1] - a[1])
            .map(([author, count]) => ({ author, count }));
    }
}

// 初始化
document.addEventListener('DOMContentLoaded', async function() {
    const library = new MemoryLibrary();
    await library.loadData();

    // 渲染统计数据
    const statsContainer = document.querySelector('.stats');
    if (statsContainer) {
        statsContainer.innerHTML = library.renderStats();
    }

    // 渲染对话卡片
    const conversationsContainer = document.querySelector('#conversations-container');
    if (conversationsContainer) {
        conversationsContainer.innerHTML = library.renderConversations();
    }

    // 渲染主题分类
    const topicsContainer = document.querySelector('#topics-container');
    if (topicsContainer) {
        topicsContainer.innerHTML = library.renderTopics();
    }

    // 渲染时间线
    const timelineContainer = document.querySelector('.timeline');
    if (timelineContainer) {
        timelineContainer.innerHTML = library.renderTimeline();
    }

    // 搜索功能
    const searchBox = document.querySelector('.search-box');
    if (searchBox) {
        searchBox.addEventListener('input', function(e) {
            const query = e.target.value;
            if (query.trim() === '') {
                conversationsContainer.innerHTML = library.renderConversations();
            } else {
                const results = library.search(query);
                if (results.length > 0) {
                    conversationsContainer.innerHTML = results
                        .map(conv => library.renderConversationCard(conv))
                        .join('');
                } else {
                    conversationsContainer.innerHTML = `
                        <div style="text-align: center; padding: 40px; color: #999;">
                            没有找到匹配的结果
                        </div>
                    `;
                }
            }
        });
    }

    // 卡片点击事件
    document.addEventListener('click', function(e) {
        const card = e.target.closest('.card[data-file]');
        if (card) {
            const file = card.dataset.file;
            window.open(file, '_blank');
        }
    });

    // 标签云渲染
    const tagsCloud = document.querySelector('#tags-cloud');
    if (tagsCloud) {
        const tags = library.getAllTags();
        tagsCloud.innerHTML = tags.map(({ tag, count }) => `
            <span class="tag" style="cursor: pointer; font-size: ${0.85 + count * 0.1}em;"
                  data-tag="${tag}">
                ${tag} (${count})
            </span>
        `).join('');

        // 标签点击过滤
        tagsCloud.addEventListener('click', function(e) {
            if (e.target.classList.contains('tag')) {
                const tag = e.target.dataset.tag;
                const results = library.filterByTag(tag);
                conversationsContainer.innerHTML = results
                    .map(conv => library.renderConversationCard(conv))
                    .join('');
                searchBox.value = `tag:${tag}`;
            }
        });
    }
});

// 导出供其他脚本使用
if (typeof module !== 'undefined' && module.exports) {
    module.exports = MemoryLibrary;
}
