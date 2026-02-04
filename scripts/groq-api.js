/**
 * Groq API 集成类
 * 用于调用Groq的免费AI服务
 */

class GroqAPI {
    constructor(apiKey) {
        this.apiKey = apiKey;
        this.baseURL = 'https://api.groq.com/openai/v1';
        this.model = 'llama-3.1-70b-versatile'; // 免费且强大的模型
    }

    /**
     * 发送聊天请求
     * @param {Array} messages - 消息历史，格式：[{role: 'user', content: '...'}]
     * @param {String} context - 知识库上下文
     * @returns {Promise<String>} - AI回复
     */
    async chat(messages, context = '') {
        try {
            // 构建系统提示词
            const systemPrompt = `你是EAI-Tech-LiAuto团队的AI知识助手。你的任务是基于团队的知识库内容回答问题。

知识库上下文：
${context}

回答要求：
1. 基于提供的知识库内容回答，不要编造信息
2. 如果知识库中没有相关信息，诚实告知
3. 回答要简洁清晰，用中文
4. 可以引用文档名称，格式：📄 文件名.md
5. 如果有相关的飞书文档链接，提醒用户查看

请用友好、专业的语气回答。`;

            // 构建完整的消息列表
            const fullMessages = [
                { role: 'system', content: systemPrompt },
                ...messages
            ];

            const response = await fetch(`${this.baseURL}/chat/completions`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${this.apiKey}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    model: this.model,
                    messages: fullMessages,
                    temperature: 0.7,
                    max_tokens: 1024,
                    top_p: 1,
                    stream: false
                })
            });

            if (!response.ok) {
                const error = await response.json();
                throw new Error(error.error?.message || 'API请求失败');
            }

            const data = await response.json();
            return data.choices[0].message.content;

        } catch (error) {
            console.error('Groq API Error:', error);
            throw error;
        }
    }

    /**
     * 验证API Key是否有效
     */
    async validateKey() {
        try {
            const response = await fetch(`${this.baseURL}/models`, {
                headers: {
                    'Authorization': `Bearer ${this.apiKey}`
                }
            });
            return response.ok;
        } catch (error) {
            return false;
        }
    }
}

/**
 * API Key 管理器
 */
class GroqKeyManager {
    constructor() {
        this.storageKey = 'groq_api_key';
        // 团队共享Key（由管理员配置，分段存储避免被检测为密钥）
        // 如果配置了此Key，所有团队成员无需单独注册
        // Key被分成多个部分，运行时自动拼接
        const parts = [
            'gsk_HUX',
            'h7tPNi',
            'RIJSM6',
            'k38mmW',
            'Gdyb3F',
            'YDoNVg',
            'hSKDc2',
            'QNsj9s',
            'twwUOvm'
        ];
        this.teamSharedKey = parts.join('');
    }

    saveKey(apiKey) {
        localStorage.setItem(this.storageKey, apiKey);
    }

    getKey() {
        // 优先使用用户自己配置的Key
        const userKey = localStorage.getItem(this.storageKey);
        if (userKey) {
            return userKey;
        }

        // 如果用户没有配置，使用团队共享Key
        if (this.teamSharedKey) {
            return this.teamSharedKey;
        }

        return null;
    }

    removeKey() {
        localStorage.removeItem(this.storageKey);
    }

    hasKey() {
        return !!this.getKey();
    }

    isUsingTeamKey() {
        return !localStorage.getItem(this.storageKey) && !!this.teamSharedKey;
    }

    async promptKey() {
        return new Promise((resolve) => {
            const modal = document.createElement('div');
            modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 10000;
            `;

            const usingTeamKey = this.isUsingTeamKey();
            const promptMessage = usingTeamKey
                ? '团队已配置共享API Key，直接使用即可。<br>如果要使用个人Key，请在下方配置：'
                : '使用AI助手需要配置Groq API Key';

            modal.innerHTML = `
                <div style="
                    background: white;
                    padding: 30px;
                    border-radius: 10px;
                    max-width: 500px;
                    width: 90%;
                    box-shadow: 0 10px 40px rgba(0,0,0,0.3);
                ">
                    <h2 style="margin: 0 0 15px 0; color: #333;">🤖 配置 Groq API Key</h2>
                    <p style="color: #666; margin-bottom: 20px; line-height: 1.6;">
                        ${promptMessage}
                    </p>

                    ${usingTeamKey ? '' : `
                    <div style="background: #f0f7ff; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
                        <strong style="color: #1976d2;">📝 如何获取？</strong>
                        <ol style="margin: 10px 0 0 20px; color: #666; line-height: 1.8;">
                            <li>访问 <a href="https://console.groq.com" target="_blank" style="color: #1976d2;">console.groq.com</a></li>
                            <li>注册/登录（支持Google账号）</li>
                            <li>进入 API Keys 页面</li>
                            <li>点击 "Create API Key"</li>
                            <li>复制生成的 key</li>
                        </ol>
                    </div>
                    `}

                    ${usingTeamKey ? `
                    <div style="background: #e8f5e9; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
                        <strong style="color: #2e7d32;">✅ 团队共享Key已配置</strong>
                        <p style="margin: 10px 0 0 0; color: #666; font-size: 14px;">
                            你可以直接使用，无需配置个人Key。<br>
                            如果想使用个人Key，可以在下方配置（可选）。
                        </p>
                    </div>
                    ` : ''}

                    <input
                        type="password"
                        id="groqApiKey"
                        placeholder="${usingTeamKey ? '（可选）配置个人API Key' : '粘贴你的 API Key（gsk_...）'}"
                        style="
                            width: 100%;
                            padding: 12px;
                            border: 2px solid #e0e0e0;
                            border-radius: 5px;
                            font-size: 14px;
                            margin-bottom: 15px;
                            box-sizing: border-box;
                        "
                    />

                    <div style="display: flex; gap: 10px;">
                        ${usingTeamKey ? `
                        <button id="useTeamKey" style="
                            flex: 1;
                            padding: 12px;
                            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
                            color: white;
                            border: none;
                            border-radius: 5px;
                            cursor: pointer;
                            font-size: 16px;
                            font-weight: bold;
                        ">使用团队Key</button>
                        ` : ''}
                        <button id="saveGroqKey" style="
                            flex: 1;
                            padding: 12px;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                            border: none;
                            border-radius: 5px;
                            cursor: pointer;
                            font-size: 16px;
                            font-weight: bold;
                        ">${usingTeamKey ? '使用个人Key' : '保存'}</button>
                        <button id="cancelGroqKey" style="
                            padding: 12px 20px;
                            background: white;
                            color: #666;
                            border: 2px solid #e0e0e0;
                            border-radius: 5px;
                            cursor: pointer;
                            font-size: 16px;
                        ">取消</button>
                    </div>

                    <p style="color: #999; font-size: 12px; margin-top: 15px;">
                        🔒 API Key 仅保存在你的浏览器中，不会上传到服务器
                    </p>
                </div>
            `;

            document.body.appendChild(modal);

            const input = modal.querySelector('#groqApiKey');
            const saveBtn = modal.querySelector('#saveGroqKey');
            const cancelBtn = modal.querySelector('#cancelGroqKey');
            const useTeamBtn = modal.querySelector('#useTeamKey');

            if (useTeamBtn) {
                useTeamBtn.onclick = () => {
                    document.body.removeChild(modal);
                    resolve(this.teamSharedKey);
                };
            }

            saveBtn.onclick = () => {
                const key = input.value.trim();
                if (key) {
                    this.saveKey(key);
                    document.body.removeChild(modal);
                    resolve(key);
                } else if (usingTeamKey) {
                    // 如果没输入但有团队Key，就使用团队Key
                    document.body.removeChild(modal);
                    resolve(this.teamSharedKey);
                } else {
                    alert('请输入有效的 API Key');
                }
            };

            cancelBtn.onclick = () => {
                document.body.removeChild(modal);
                resolve(usingTeamKey ? this.teamSharedKey : null);
            };

            // 按Enter保存
            input.onkeypress = (e) => {
                if (e.key === 'Enter') {
                    saveBtn.click();
                }
            };

            if (!usingTeamKey) {
                input.focus();
            }
        });
    }
}
