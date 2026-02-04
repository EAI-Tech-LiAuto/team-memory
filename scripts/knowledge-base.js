/**
 * 知识库管理器
 * 负责索引和搜索团队知识库中的所有文档
 */

class KnowledgeBase {
    constructor() {
        this.documents = [];
        this.index = new Map();
        this.repoOwner = 'EAI-Tech-LiAuto';
        this.repoName = 'team-memory';
    }

    /**
     * 初始化知识库（加载所有文档）
     */
    async initialize() {
        console.log('正在加载知识库...');

        try {
            // 加载对话记录
            await this.loadConversations();

            // 加载调研记录
            await this.loadResearch();

            // 构建搜索索引
            this.buildIndex();

            console.log(`知识库加载完成，共 ${this.documents.length} 个文档`);
            return true;
        } catch (error) {
            console.error('知识库加载失败:', error);
            return false;
        }
    }

    /**
     * 加载对话记录
     */
    async loadConversations() {
        const folders = ['2026-01', '2026-02'];

        for (const folder of folders) {
            try {
                const url = `https://api.github.com/repos/${this.repoOwner}/${this.repoName}/contents/conversations/${folder}`;
                const response = await fetch(url);

                if (!response.ok) continue;

                const files = await response.json();

                for (const file of files) {
                    if (file.name.endsWith('.md')) {
                        await this.loadDocument(file.download_url, 'conversation', folder);
                    }
                }
            } catch (error) {
                console.warn(`无法加载文件夹 ${folder}:`, error);
            }
        }
    }

    /**
     * 加载调研记录
     */
    async loadResearch() {
        try {
            const url = `https://api.github.com/repos/${this.repoOwner}/${this.repoName}/contents/research/companies`;
            const response = await fetch(url);

            if (!response.ok) return;

            const files = await response.json();

            for (const file of files) {
                if (file.name.endsWith('.md')) {
                    await this.loadDocument(file.download_url, 'research', 'companies');
                }
            }
        } catch (error) {
            console.warn('无法加载调研记录:', error);
        }
    }

    /**
     * 加载单个文档
     */
    async loadDocument(url, type, category) {
        try {
            const response = await fetch(url);
            const content = await response.text();

            // 解析frontmatter和内容
            const parsed = this.parseMarkdown(content);

            // 从URL提取文件名
            const filename = url.split('/').pop();

            this.documents.push({
                filename,
                type,
                category,
                url,
                title: parsed.metadata.topic || parsed.metadata.name || filename,
                metadata: parsed.metadata,
                content: parsed.content,
                fullText: content
            });
        } catch (error) {
            console.warn(`无法加载文档 ${url}:`, error);
        }
    }

    /**
     * 解析Markdown文档
     */
    parseMarkdown(markdown) {
        const frontmatterMatch = markdown.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);

        if (!frontmatterMatch) {
            return { metadata: {}, content: markdown };
        }

        const frontmatter = frontmatterMatch[1];
        const content = frontmatterMatch[2];

        // 解析YAML
        const metadata = {};
        frontmatter.split('\n').forEach(line => {
            const match = line.match(/^([^:]+):\s*(.+)$/);
            if (match) {
                let value = match[2].trim();
                // 处理数组格式
                if (value.startsWith('[') && value.endsWith(']')) {
                    value = value.slice(1, -1).split(',').map(s => s.trim());
                }
                metadata[match[1].trim()] = value;
            }
        });

        return { metadata, content };
    }

    /**
     * 构建搜索索引
     */
    buildIndex() {
        this.index.clear();

        this.documents.forEach((doc, docIndex) => {
            // 提取关键词
            const keywords = this.extractKeywords(doc);

            keywords.forEach(keyword => {
                if (!this.index.has(keyword)) {
                    this.index.set(keyword, []);
                }
                this.index.get(keyword).push(docIndex);
            });
        });
    }

    /**
     * 提取文档关键词
     */
    extractKeywords(doc) {
        const keywords = new Set();

        // 标题
        if (doc.title) {
            this.tokenize(doc.title).forEach(k => keywords.add(k));
        }

        // 标签
        if (doc.metadata.tags) {
            const tags = Array.isArray(doc.metadata.tags) ? doc.metadata.tags : [doc.metadata.tags];
            tags.forEach(tag => {
                this.tokenize(tag).forEach(k => keywords.add(k));
            });
        }

        // 内容（提取前1000字）
        const contentPreview = doc.content.substring(0, 1000);
        this.tokenize(contentPreview).forEach(k => keywords.add(k));

        return Array.from(keywords);
    }

    /**
     * 简单分词（中文按字符，英文按单词）
     */
    tokenize(text) {
        const tokens = new Set();

        // 转小写
        text = text.toLowerCase();

        // 移除标点符号
        text = text.replace(/[^\w\s\u4e00-\u9fa5]/g, ' ');

        // 英文单词
        const words = text.match(/[a-z]+/g) || [];
        words.forEach(w => {
            if (w.length >= 2) tokens.add(w);
        });

        // 中文字符（2-gram）
        const chinese = text.match(/[\u4e00-\u9fa5]/g) || [];
        for (let i = 0; i < chinese.length - 1; i++) {
            tokens.add(chinese[i] + chinese[i + 1]);
        }
        chinese.forEach(c => tokens.add(c));

        return Array.from(tokens);
    }

    /**
     * 搜索知识库
     * @param {String} query - 查询关键词
     * @param {Number} limit - 返回结果数量
     */
    search(query, limit = 5) {
        const queryTokens = this.tokenize(query);
        const scores = new Map();

        // 计算每个文档的相关性分数
        queryTokens.forEach(token => {
            const docIndices = this.index.get(token) || [];
            docIndices.forEach(docIndex => {
                scores.set(docIndex, (scores.get(docIndex) || 0) + 1);
            });
        });

        // 排序并返回Top N
        const results = Array.from(scores.entries())
            .sort((a, b) => b[1] - a[1])
            .slice(0, limit)
            .map(([docIndex, score]) => ({
                document: this.documents[docIndex],
                score
            }));

        return results;
    }

    /**
     * 获取搜索结果的上下文摘要
     */
    getContextSummary(results, maxLength = 2000) {
        if (results.length === 0) {
            return '知识库中暂无相关内容。';
        }

        let summary = '';

        results.forEach((result, index) => {
            const doc = result.document;
            const preview = doc.content.substring(0, 300).replace(/\n+/g, ' ');

            summary += `\n【文档${index + 1}】${doc.title}\n`;
            summary += `类型: ${doc.type === 'conversation' ? '对话记录' : '调研记录'}\n`;

            if (doc.metadata.tags) {
                const tags = Array.isArray(doc.metadata.tags) ? doc.metadata.tags.join(', ') : doc.metadata.tags;
                summary += `标签: ${tags}\n`;
            }

            summary += `内容摘要: ${preview}...\n`;
            summary += `文件名: ${doc.filename}\n`;
        });

        // 限制总长度
        if (summary.length > maxLength) {
            summary = summary.substring(0, maxLength) + '\n...(内容过长已截断)';
        }

        return summary;
    }

    /**
     * 获取统计信息
     */
    getStats() {
        const conversations = this.documents.filter(d => d.type === 'conversation').length;
        const research = this.documents.filter(d => d.type === 'research').length;

        return {
            total: this.documents.length,
            conversations,
            research,
            keywords: this.index.size
        };
    }
}
