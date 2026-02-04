/**
 * AI助手聊天组件
 * 类似豆包的对话界面
 */

class ChatAssistant {
    constructor() {
        this.groqAPI = null;
        this.knowledgeBase = new KnowledgeBase();
        this.conversationHistory = [];
        this.isOpen = false;
        this.isInitialized = false;

        this.init();
    }

    /**
     * 初始化组件
     */
    async init() {
        // 创建UI
        this.createUI();

        // 绑定事件
        this.bindEvents();

        // 加载知识库（后台加载）
        this.loadKnowledgeBase();
    }

    /**
     * 创建UI元素
     */
    createUI() {
        // 浮动按钮
        const floatingButton = document.createElement('div');
        floatingButton.id = 'chatFloatingButton';
        floatingButton.innerHTML = '🤖';
        floatingButton.style.cssText = `
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-size: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 20px rgba(102, 126, 234, 0.4);
            z-index: 9998;
            transition: all 0.3s ease;
        `;

        floatingButton.onmouseenter = () => {
            floatingButton.style.transform = 'scale(1.1)';
            floatingButton.style.boxShadow = '0 6px 25px rgba(102, 126, 234, 0.6)';
        };

        floatingButton.onmouseleave = () => {
            floatingButton.style.transform = 'scale(1)';
            floatingButton.style.boxShadow = '0 4px 20px rgba(102, 126, 234, 0.4)';
        };

        // 聊天窗口
        const chatWindow = document.createElement('div');
        chatWindow.id = 'chatWindow';
        chatWindow.style.cssText = `
            position: fixed;
            bottom: 100px;
            right: 30px;
            width: 400px;
            height: 600px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            display: none;
            flex-direction: column;
            z-index: 9999;
            overflow: hidden;
        `;

        chatWindow.innerHTML = `
            <div style="
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            ">
                <div>
                    <h3 style="margin: 0; font-size: 18px;">🤖 AI知识助手</h3>
                    <p style="margin: 5px 0 0 0; font-size: 12px; opacity: 0.9;">基于团队知识库</p>
                </div>
                <button id="chatCloseButton" style="
                    background: none;
                    border: none;
                    color: white;
                    font-size: 24px;
                    cursor: pointer;
                    padding: 0;
                    width: 30px;
                    height: 30px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                ">×</button>
            </div>

            <div id="chatMessages" style="
                flex: 1;
                overflow-y: auto;
                padding: 20px;
                background: #f5f5f5;
            ">
                <div class="chat-message assistant">
                    <div class="message-content">
                        你好！我是团队知识库AI助手 🤖<br><br>
                        你可以问我：<br>
                        • 人形机器人的技术方案<br>
                        • 调研过的企业信息<br>
                        • 团队讨论的内容<br>
                        • 相关技术文档<br><br>
                        试试问我问题吧！
                    </div>
                </div>
            </div>

            <div style="
                padding: 15px;
                background: white;
                border-top: 1px solid #e0e0e0;
                display: flex;
                gap: 10px;
            ">
                <input
                    id="chatInput"
                    type="text"
                    placeholder="输入你的问题..."
                    style="
                        flex: 1;
                        padding: 12px;
                        border: 2px solid #e0e0e0;
                        border-radius: 20px;
                        font-size: 14px;
                        outline: none;
                    "
                />
                <button id="chatSendButton" style="
                    width: 45px;
                    height: 45px;
                    border-radius: 50%;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border: none;
                    color: white;
                    font-size: 20px;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                ">▶</button>
            </div>
        `;

        // 添加样式
        const style = document.createElement('style');
        style.textContent = `
            .chat-message {
                margin-bottom: 15px;
                animation: slideIn 0.3s ease;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .message-content {
                padding: 12px 16px;
                border-radius: 12px;
                max-width: 85%;
                word-wrap: break-word;
                line-height: 1.6;
            }

            .chat-message.user .message-content {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                margin-left: auto;
            }

            .chat-message.assistant .message-content {
                background: white;
                color: #333;
                border: 1px solid #e0e0e0;
            }

            .chat-message.assistant .message-content a {
                color: #667eea;
                text-decoration: none;
            }

            .chat-message.assistant .message-content a:hover {
                text-decoration: underline;
            }

            .typing-indicator {
                display: flex;
                gap: 5px;
                padding: 12px 16px;
            }

            .typing-indicator span {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: #999;
                animation: typing 1.4s infinite;
            }

            .typing-indicator span:nth-child(2) {
                animation-delay: 0.2s;
            }

            .typing-indicator span:nth-child(3) {
                animation-delay: 0.4s;
            }

            @keyframes typing {
                0%, 60%, 100% {
                    transform: translateY(0);
                }
                30% {
                    transform: translateY(-10px);
                }
            }

            #chatInput:focus {
                border-color: #667eea;
            }

            #chatSendButton:hover {
                transform: scale(1.05);
            }

            #chatSendButton:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }

            @media (max-width: 768px) {
                #chatWindow {
                    width: calc(100% - 40px);
                    height: calc(100% - 120px);
                    right: 20px;
                    bottom: 80px;
                }
            }
        `;

        document.head.appendChild(style);
        document.body.appendChild(floatingButton);
        document.body.appendChild(chatWindow);

        this.floatingButton = floatingButton;
        this.chatWindow = chatWindow;
        this.chatMessages = chatWindow.querySelector('#chatMessages');
        this.chatInput = chatWindow.querySelector('#chatInput');
        this.chatSendButton = chatWindow.querySelector('#chatSendButton');
    }

    /**
     * 绑定事件
     */
    bindEvents() {
        // 打开/关闭聊天窗口
        this.floatingButton.onclick = () => this.toggle();

        const closeButton = this.chatWindow.querySelector('#chatCloseButton');
        closeButton.onclick = () => this.close();

        // 发送消息
        this.chatSendButton.onclick = () => this.sendMessage();

        // 回车发送
        this.chatInput.onkeypress = (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                this.sendMessage();
            }
        };
    }

    /**
     * 加载知识库
     */
    async loadKnowledgeBase() {
        try {
            const success = await this.knowledgeBase.initialize();
            if (success) {
                this.isInitialized = true;
                console.log('知识库加载成功');
            }
        } catch (error) {
            console.error('知识库加载失败:', error);
        }
    }

    /**
     * 切换聊天窗口
     */
    toggle() {
        if (this.isOpen) {
            this.close();
        } else {
            this.open();
        }
    }

    /**
     * 打开聊天窗口
     */
    async open() {
        // 检查API Key
        const keyManager = new GroqKeyManager();
        if (!keyManager.hasKey()) {
            const key = await keyManager.promptKey();
            if (!key) return;
        }

        this.chatWindow.style.display = 'flex';
        this.floatingButton.innerHTML = '✕';
        this.isOpen = true;
        this.chatInput.focus();
    }

    /**
     * 关闭聊天窗口
     */
    close() {
        this.chatWindow.style.display = 'none';
        this.floatingButton.innerHTML = '🤖';
        this.isOpen = false;
    }

    /**
     * 发送消息
     */
    async sendMessage() {
        const message = this.chatInput.value.trim();
        if (!message) return;

        // 清空输入框
        this.chatInput.value = '';

        // 显示用户消息
        this.addMessage(message, 'user');

        // 禁用发送按钮
        this.chatSendButton.disabled = true;

        // 显示"正在输入"提示
        const typingIndicator = this.addTypingIndicator();

        try {
            // 搜索知识库
            const searchResults = this.knowledgeBase.search(message, 3);

            // 获取上下文
            const context = this.knowledgeBase.getContextSummary(searchResults, 1500);

            // 准备消息历史
            const messages = [
                ...this.conversationHistory,
                { role: 'user', content: message }
            ];

            // 调用AI
            const keyManager = new GroqKeyManager();
            const apiKey = keyManager.getKey();

            if (!this.groqAPI) {
                this.groqAPI = new GroqAPI(apiKey);
            }

            const response = await this.groqAPI.chat(messages, context);

            // 移除"正在输入"提示
            this.removeTypingIndicator(typingIndicator);

            // 显示AI回复
            this.addMessage(response, 'assistant', searchResults);

            // 更新对话历史
            this.conversationHistory.push(
                { role: 'user', content: message },
                { role: 'assistant', content: response }
            );

            // 限制历史长度
            if (this.conversationHistory.length > 10) {
                this.conversationHistory = this.conversationHistory.slice(-10);
            }

        } catch (error) {
            // 移除"正在输入"提示
            this.removeTypingIndicator(typingIndicator);

            // 显示错误消息
            this.addMessage(
                `抱歉，出现错误：${error.message}\n\n请检查：\n1. API Key是否正确\n2. 网络连接是否正常\n3. 是否超出使用限额`,
                'assistant'
            );
        } finally {
            // 启用发送按钮
            this.chatSendButton.disabled = false;
            this.chatInput.focus();
        }
    }

    /**
     * 添加消息到聊天窗口
     */
    addMessage(content, role, searchResults = null) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `chat-message ${role}`;

        let messageHTML = `<div class="message-content">${this.formatMessage(content)}`;

        // 如果有搜索结果，添加相关文档链接
        if (searchResults && searchResults.length > 0) {
            messageHTML += '<br><br><div style="font-size: 12px; color: #999; border-top: 1px solid #e0e0e0; padding-top: 10px; margin-top: 10px;">';
            messageHTML += '📚 <strong>相关文档:</strong><br>';
            searchResults.forEach(result => {
                const doc = result.document;
                const viewerUrl = `viewer.html?file=./${doc.type === 'conversation' ? 'conversations/' + doc.category : 'research/companies'}/${doc.filename}`;
                messageHTML += `📄 <a href="${viewerUrl}" target="_blank">${doc.title}</a><br>`;
            });
            messageHTML += '</div>';
        }

        messageHTML += '</div>';
        messageDiv.innerHTML = messageHTML;

        this.chatMessages.appendChild(messageDiv);
        this.chatMessages.scrollTop = this.chatMessages.scrollHeight;
    }

    /**
     * 格式化消息（支持简单markdown）
     */
    formatMessage(text) {
        return text
            .replace(/\n/g, '<br>')
            .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
            .replace(/\*(.*?)\*/g, '<em>$1</em>')
            .replace(/`(.*?)`/g, '<code style="background:#f0f0f0;padding:2px 5px;border-radius:3px;">$1</code>');
    }

    /**
     * 添加"正在输入"提示
     */
    addTypingIndicator() {
        const indicator = document.createElement('div');
        indicator.className = 'chat-message assistant';
        indicator.innerHTML = `
            <div class="message-content">
                <div class="typing-indicator">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </div>
        `;
        this.chatMessages.appendChild(indicator);
        this.chatMessages.scrollTop = this.chatMessages.scrollHeight;
        return indicator;
    }

    /**
     * 移除"正在输入"提示
     */
    removeTypingIndicator(indicator) {
        if (indicator && indicator.parentNode) {
            indicator.parentNode.removeChild(indicator);
        }
    }
}

// 自动初始化
if (typeof window !== 'undefined') {
    window.addEventListener('DOMContentLoaded', () => {
        window.chatAssistant = new ChatAssistant();
    });
}
