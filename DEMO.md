# 🎬 团队共享记忆库 - 完整演示

## ✅ 已创建的内容

### 📁 文件结构
```
~/team-memory-repo/
├── 📄 CLAUDE.md                        # 主知识库索引和使用指南
├── 📄 QUICKSTART.md                    # 快速开始指南
├── 📄 .gitignore                        # Git忽略规则
├── 🌐 index.html                        # Web可视化界面
├── 📁 conversations/                    # 对话记录
│   └── 2026-01/
│       ├── embodied-ai-research.md     # 具身智能企业调研
│       └── git-shared-memory-design.md # Git共享记忆系统设计
├── 📁 topics/                           # 主题分类知识
│   ├── architecture/
│   ├── features/
│   ├── debugging/
│   └── research/
├── 📁 decisions/                        # 架构决策记录(ADR)
├── 📁 workflows/                        # 工作流程文档
├── 📁 context/                          # 项目上下文
└── 📁 scripts/                          # 自动化脚本
    ├── capture.bat                      # Windows快速捕获脚本
    ├── capture.sh                       # Linux/Mac快速捕获脚本
    └── app.js                           # Web界面数据引擎

~/my-demo-project/                       # 演示项目
├── .claude.local.md                     # 项目本地上下文(引用记忆库)
└── README.md                            # 项目说明
```

### 📊 当前统计
- **对话记录**: 2篇
- **主题文档**: 2个主题方向
- **Git提交**: 1次（初始化）
- **贡献者**: 1人 (lijun13)

## 🚀 使用演示

### 场景1: 查看Web可视化界面

#### Step 1: 打开Web界面
```bash
# 方法1: 直接用浏览器打开
# Windows: 在文件管理器中双击 ~/team-memory-repo/index.html

# 方法2: 启动本地服务器（推荐）
cd ~/team-memory-repo
python -m http.server 8000
# 浏览器访问: http://localhost:8000
```

#### Web界面功能展示：

**🏠 首页**
- 统计卡片：显示对话数、主题数、决策数、贡献者数
- 搜索框：实时搜索对话内容、标签、作者
- 快速导航：6个主题分类的快捷链接

**📱 最新对话区**
- 卡片式展示所有对话
- 每个卡片包含：标题、日期、作者、标签、摘要
- 点击卡片可跳转到原始Markdown文件
- 悬停效果：卡片上浮+阴影

**🏷️ 主题分类区**
- 展示4大主题分类
- 显示每个主题的文档数量
- 列出主题下的具体内容

**⏱️ 时间线区**
- 按时间倒序显示所有对话
- 时间轴可视化设计
- 快速浏览团队知识演进过程

**🔍 搜索功能**
- 实时搜索：输入即刻过滤
- 支持搜索：标题、摘要、标签、作者
- 无结果时显示友好提示

### 场景2: 捕获新的对话

#### Step 1: 运行捕获脚本
```bash
cd ~/team-memory-repo

# Windows用户
scripts\capture.bat "my-new-feature-discussion"

# Linux/Mac用户
./scripts/capture.sh my-new-feature-discussion alice
```

#### Step 2: 编辑生成的文件
脚本会自动创建 `conversations/2026-01/my-new-feature-discussion.md` 并打开编辑器。

模板内容：
```markdown
---
date: 2026-01-27
author: yourname
topic: my-new-feature-discussion
tags: []
related_files: []
status: draft
---

# my-new-feature-discussion

## 会话背景
[填写对话背景]

## 关键发现
[记录重要发现]

## 代码示例
[如果有代码]

## 后续行动
- [ ] 待办事项1
```

#### Step 3: 提交到Git
```bash
git add .
git commit -m "feat(feature): 添加新功能讨论 by @yourname"
git push  # 如果已配置远程仓库
```

### 场景3: 在项目中引用团队记忆

#### Step 1: 创建项目本地上下文
```bash
cd ~/my-project
cat > .claude.local.md << 'EOF'
# 项目本地上下文

## 团队记忆引用
参考: ~/team-memory-repo/

相关主题:
- [具身智能调研](~/team-memory-repo/conversations/2026-01/embodied-ai-research.md)

## 当前任务
实现用户认证功能
EOF
```

#### Step 2: 启动Claude Code
```bash
cd ~/my-project
claude code
```

#### Step 3: 与Claude Code交互
```
你: "查看团队记忆库中关于具身智能的调研"

Claude: [读取并总结 embodied-ai-research.md 的内容]

你: "基于团队的知识管理系统设计，帮我设计一个认证系统"

Claude: [参考 git-shared-memory-design.md，设计认证系统]

你: "这次对话很有价值，帮我记录到团队记忆库"

Claude: [可以帮你生成记录模板]
```

### 场景4: 团队协作流程

#### 团队成员A (上午)
```bash
# 1. 获取最新知识
cd ~/team-memory-repo
git pull

# 2. 查看最新更新
git log -3 --oneline

# 3. 浏览Web界面了解团队动态
python -m http.server 8000

# 4. 开始工作，在项目中引用记忆库
cd ~/my-project
# 创建 .claude.local.md 引用相关主题

# 5. 与Claude Code协作开发
claude code
```

#### 团队成员B (下午)
```bash
# 1. 成员A完成工作后
cd ~/team-memory-repo
git pull  # 拉取成员A的新增对话

# 2. 阅读成员A的对话记录
cat conversations/2026-01/feature-a-implementation.md

# 3. 在此基础上继续工作
cd ~/my-project
# 更新 .claude.local.md，引用成员A的对话

# 4. 完成后记录自己的对话
cd ~/team-memory-repo
./scripts/capture.bat "feature-b-implementation"

# 5. 提交并推送
git add . && git commit -m "feat: 添加Feature B实现讨论 by @memberB"
git push
```

### 场景5: 搜索和查询

#### 使用Git Grep搜索
```bash
cd ~/team-memory-repo

# 搜索所有包含"架构"的对话
git grep "架构" conversations/

# 搜索特定作者的对话
git grep "author: alice" conversations/

# 搜索特定标签
git grep "tags:.*research" conversations/
```

#### 使用Web界面搜索
1. 打开 `index.html`
2. 在顶部搜索框输入关键词
3. 实时过滤结果

#### 与Claude Code交互搜索
```
"在团队记忆库中搜索关于性能优化的讨论"
"列出团队所有关于架构决策的记录"
"总结最近一个月团队的主要工作"
```

### 场景6: 定期维护

#### 每周整理（周五下午）
```bash
cd ~/team-memory-repo

# 1. 查看本周新增内容
git log --since="1 week ago" --oneline

# 2. 审查对话记录，提炼到主题文档
# 编辑 topics/ 下的文件

# 3. 更新CLAUDE.md的"最近更新"部分

# 4. 提交整理成果
git add .
git commit -m "docs: 第X周知识整理"
git push
```

#### 每月归档（月末）
```bash
# 1. 检查过时内容
# 2. 移动到 archive/ 目录
# 3. 更新索引和统计
# 4. 生成月度知识报告
```

## 📸 Web界面预览

```
┌─────────────────────────────────────────────────────┐
│          🧠 团队共享记忆库                              │
│     团队与Claude Code交流的集体智慧中心                   │
└─────────────────────────────────────────────────────┘

┌─────────┬─────────┬─────────┬─────────┐
│    2    │    1    │    0    │    1    │
│ 对话记录 │ 主题文档 │ 架构决策 │ 贡献者   │
└─────────┴─────────┴─────────┴─────────┘

🔍 [搜索对话、主题、标签...]

📱 快速导航
[📐 架构决策] [⚙️ 功能实现] [🐛 调试经验]
[🔬 研究调研] [📋 决策记录] [🔄 工作流程]

🆕 最新对话
┌─────────────────────────────────┐
│ Git共享记忆系统设计       2026-01-27│
│ 👤 lijun13                        │
│ [architecture] [knowledge]        │
│ 基于Git和Claude Code...           │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ 具身智能企业调研         2026-01-27│
│ 👤 lijun13                        │
│ [research] [embodied-ai]          │
│ 国内外具身智能领域...              │
└─────────────────────────────────┘
```

## 🎯 核心价值验证

### ✅ 集体智慧积累
- 每个人的对话都被系统化保存
- 知识不再散落在个人笔记中
- 形成团队的"第二大脑"

### ✅ 知识可追溯
- 完整的Git历史记录
- 可以看到知识的演进过程
- 任何改动都有据可查

### ✅ 快速查找
- Web界面实时搜索
- Git grep命令行搜索
- Claude Code智能查询

### ✅ 新人友好
- 结构化的知识组织
- 清晰的主题分类
- 完整的对话上下文

### ✅ 持续进化
- 随项目发展不断完善
- 定期整理和归档
- 集成到日常工作流

## 🔧 技术实现亮点

### 1. 无需数据库
- 纯文件系统存储
- Markdown格式易读易写
- Git管理版本和协作

### 2. 零依赖Web界面
- 单个HTML文件
- 无需Node.js或构建工具
- 双击即可打开使用

### 3. 与Claude Code深度集成
- 通过CLAUDE.md自动加载
- 支持.claude.local.md个人覆盖
- Claude Code原生理解Markdown

### 4. 开发者友好
- 熟悉的Git工作流
- 命令行脚本自动化
- 支持VSCode等编辑器

## 📝 下一步建议

### 立即可做：
1. ✅ 用浏览器打开 `~/team-memory-repo/index.html` 查看效果
2. ✅ 运行 `scripts/capture.bat` 体验快速捕获
3. ✅ 在Claude Code中引用记忆库测试

### 短期优化：
1. 配置Git远程仓库（GitHub/GitLab）
2. 邀请团队成员克隆使用
3. 建立团队使用规范文档
4. 设置定期整理时间

### 长期规划：
1. 开发更多自动化工具
2. 集成到CI/CD流程
3. 实现知识图谱可视化
4. 开发移动端查看应用

## 🆘 常见问题

**Q: Web界面是静态的吗？**
A: 是的，但包含完整的JavaScript交互功能（搜索、过滤、卡片动效）。如需动态加载文件，可以配置本地服务器。

**Q: 如何让Web界面自动加载最新对话？**
A: 修改 `scripts/app.js` 中的数据，或开发Python/Node.js脚本扫描conversations目录生成数据。

**Q: 可以部署到内网服务器吗？**
A: 可以！将整个team-memory-repo目录放到Web服务器即可。推荐用GitHub Pages或内网GitLab Pages。

**Q: 如何处理敏感信息？**
A: 使用.gitignore忽略敏感文件，或在.claude.local.md中记录（不提交到Git）。

**Q: 如何与现有的Notion/Confluence集成？**
A: 可以写脚本导出Markdown到记忆库，或在记忆库中添加外部链接。

---

## 🎊 演示完成！

你现在拥有一个完整的团队共享记忆系统，包括：
- ✅ 文件结构和Git版本控制
- ✅ 2篇完整的对话记录示例
- ✅ 精美的Web可视化界面
- ✅ 自动化捕获脚本
- ✅ 项目集成示例
- ✅ 完整的使用文档

**文件位置**:
- 记忆库: `C:\Users\lijun13\team-memory-repo\`
- Web界面: `C:\Users\lijun13\team-memory-repo\index.html`
- 演示项目: `C:\Users\lijun13\my-demo-project\`

**立即体验**: 在文件管理器中打开 `C:\Users\lijun13\team-memory-repo\index.html` 🚀
