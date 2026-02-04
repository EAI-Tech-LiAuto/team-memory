/**
 * GitHub API Manager for Team Memory
 * 用于在线编辑和保存文件到GitHub仓库
 */

class GitHubAPI {
    constructor(token, owner, repo) {
        this.token = token;
        this.owner = owner;
        this.repo = repo;
        this.baseURL = 'https://api.github.com';
    }

    /**
     * 获取文件内容
     */
    async getFile(path) {
        const url = `${this.baseURL}/repos/${this.owner}/${this.repo}/contents/${path}`;
        const response = await fetch(url, {
            headers: {
                'Authorization': `Bearer ${this.token}`,
                'Accept': 'application/vnd.github.v3+json'
            }
        });

        if (!response.ok) {
            throw new Error(`获取文件失败: ${response.statusText}`);
        }

        const data = await response.json();
        // Base64 解码
        const content = decodeURIComponent(escape(atob(data.content)));
        return {
            content: content,
            sha: data.sha // 更新时需要
        };
    }

    /**
     * 创建或更新文件
     */
    async saveFile(path, content, message, sha = null) {
        const url = `${this.baseURL}/repos/${this.owner}/${this.repo}/contents/${path}`;

        // Base64 编码
        const encodedContent = btoa(unescape(encodeURIComponent(content)));

        const body = {
            message: message,
            content: encodedContent,
            branch: 'main'
        };

        // 如果是更新，需要提供 sha
        if (sha) {
            body.sha = sha;
        }

        const response = await fetch(url, {
            method: 'PUT',
            headers: {
                'Authorization': `Bearer ${this.token}`,
                'Accept': 'application/vnd.github.v3+json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(body)
        });

        if (!response.ok) {
            const error = await response.json();
            throw new Error(`保存失败: ${error.message || response.statusText}`);
        }

        return await response.json();
    }

    /**
     * 检查 token 是否有效
     */
    async validateToken() {
        const url = `${this.baseURL}/user`;
        try {
            const response = await fetch(url, {
                headers: {
                    'Authorization': `Bearer ${this.token}`,
                    'Accept': 'application/vnd.github.v3+json'
                }
            });
            return response.ok;
        } catch (error) {
            return false;
        }
    }
}

/**
 * Token 管理器
 */
class TokenManager {
    constructor() {
        this.storageKey = 'github_token';
    }

    // 保存 token 到 localStorage
    saveToken(token) {
        localStorage.setItem(this.storageKey, token);
    }

    // 获取 token
    getToken() {
        return localStorage.getItem(this.storageKey);
    }

    // 删除 token
    removeToken() {
        localStorage.removeItem(this.storageKey);
    }

    // 检查是否有 token
    hasToken() {
        return !!this.getToken();
    }

    // 提示用户输入 token
    async promptToken() {
        const token = prompt(
            '请输入 GitHub Personal Access Token:\n\n' +
            '如何获取：\n' +
            '1. 访问 https://github.com/settings/tokens\n' +
            '2. 生成新的 token (classic)\n' +
            '3. 勾选 repo 权限\n' +
            '4. 复制 token 并粘贴到这里\n\n' +
            'Token 将保存在浏览器中，下次无需重新输入。'
        );

        if (token) {
            this.saveToken(token);
            return token;
        }
        return null;
    }
}

// 导出给全局使用
window.GitHubAPI = GitHubAPI;
window.TokenManager = TokenManager;
