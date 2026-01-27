# 🧠 团队共享记忆库

> 基于Git和Claude Code的团队知识管理系统

让团队每个人与Claude Code的对话汇总到一起，形成集体智慧资产。

![Status](https://img.shields.io/badge/status-active-success)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ 特性

- 📝 **对话记录系统** - 结构化捕获与Claude Code的每次重要对话
- 🌐 **Web可视化界面** - 精美的界面浏览、搜索、过滤知识
- 🔍 **强大的搜索** - 实时搜索对话、标签、作者
- 📊 **主题分类** - 按架构、功能、调试、研究等分类组织
- ⏱️ **时间线视图** - 直观展示知识演进过程
- 🤖 **Claude Code集成** - 通过CLAUDE.md自动加载上下文
- 🔄 **Git版本控制** - 完整的历史追溯和团队协作
- 🚀 **零依赖部署** - 纯HTML+JS，双击即用

## 🎬 快速预览

```
📁 team-memory-repo/
├── 🌐 index.html          # 打开查看精美界面
├── 📄 CLAUDE.md           # 主文档
├── 📝 QUICKSTART.md       # 5分钟入门
├── 🎯 DEMO.md             # 完整演示指南
├── 📁 conversations/      # 对话记录
├── 📁 topics/             # 主题知识库
├── 📁 decisions/          # 架构决策(ADR)
└── 📁 scripts/            # 自动化工具
    ├── capture.bat        # Windows快速捕获
    └── capture.sh         # Linux/Mac快速捕获
```

## 🚀 快速开始

### 1. 查看Web界面

在文件管理器中双击打开：
```
C:\Users\lijun13\team-memory-repo\index.html
```

或使用本地服务器：
```bash
cd ~/team-memory-repo
python -m http.server 8000
# 浏览器访问 http://localhost:8000
```

### 2. 捕获新对话

```bash
cd ~/team-memory-repo
scripts\capture.bat my-topic-name    # Windows
./scripts/capture.sh my-topic-name   # Linux/Mac
```

### 3. 在项目中使用

在你的项目根目录创建 `.claude.local.md`:
```markdown
## 团队记忆引用
参考: ~/team-memory-repo/

相关主题:
- [具身智能调研](~/team-memory-repo/conversations/2026-01/embodied-ai-research.md)
```

### 4. 提交到Git

```bash
git add .
git commit -m "feat: 添加XX讨论 by @yourname"
git push
```

## 📚 文档导航

| 文档 | 说明 | 适合 |
|------|------|------|
| [CLAUDE.md](./CLAUDE.md) | 主文档和使用指南 | 所有人 |
| [QUICKSTART.md](./QUICKSTART.md) | 5分钟快速开始 | 新手 |
| [DEMO.md](./DEMO.md) | 完整演示和场景 | 深入了解 |
| [index.html](./index.html) | Web可视化界面 | 浏览知识 |

## 📊 当前状态

- **对话记录**: 2篇（具身智能调研、Git共享记忆系统设计）
- **主题文档**: 2个方向（研究、架构）
- **架构决策**: 0个
- **贡献者**: 1人

## 🎯 核心理念

### 问题
- 团队成员与Claude Code的对话散落各处
- 相同问题重复讨论，浪费时间
- 新成员难以快速了解项目历史
- 技术决策缺乏记录和追溯

### 解决方案
- ✅ 系统化捕获每次重要对话
- ✅ Git版本控制，完整历史追溯
- ✅ 结构化组织，快速查找
- ✅ Web界面，友好的浏览体验
- ✅ 与Claude Code深度集成

### 价值
- 📈 知识资产持续积累
- 🤝 团队协作更高效
- 🎓 新人上手更快速
- 🔍 决策有据可查
- 🧠 形成"集体大脑"

## 💡 使用场景

### 场景1: 技术调研
```bash
# Alice做了具身智能调研
./scripts/capture.bat embodied-ai-research
git commit -m "feat(research): 具身智能企业调研 by @alice"

# Bob可以直接查看Alice的调研成果
git pull
cat conversations/2026-01/embodied-ai-research.md
```

### 场景2: 架构决策
```bash
# 团队讨论后记录决策
./scripts/capture.bat jwt-vs-session-decision
# 归档到decisions/作为ADR
git commit -m "docs(adr): 添加JWT vs Session决策 by @team"
```

### 场景3: 问题调试
```bash
# Charlie解决了一个棘手的bug
./scripts/capture.bat redis-connection-issue
# 记录问题、分析过程、解决方案
git commit -m "fix(debug): Redis连接问题解决方案 by @charlie"
```

## 🛠️ 技术栈

- **存储**: 文件系统 + Markdown
- **版本控制**: Git
- **前端界面**: HTML + CSS + Vanilla JS
- **集成**: Claude Code (CLAUDE.md)
- **自动化**: Bash/Batch脚本

## 🔧 高级功能

### 搜索和查询
```bash
# Git搜索
git grep "架构" conversations/

# Web界面搜索（实时过滤）
# 打开index.html，使用搜索框

# Claude Code智能查询
"在团队记忆库中搜索关于性能优化的讨论"
```

### 标签系统
```yaml
tags:
  - research      # 研究调研
  - architecture  # 架构设计
  - debugging     # 问题调试
  - feature       # 功能实现
```

### 时间线视图
Web界面中的时间线功能，直观展示知识演进过程。

## 🤝 团队协作

### 工作流
```bash
# 1. 早上拉取最新知识
git pull

# 2. 开发过程中引用记忆库
cd ~/my-project
# 在.claude.local.md中引用相关主题

# 3. 重要对话后记录
cd ~/team-memory-repo
./scripts/capture.bat my-discussion

# 4. 提交并推送
git add . && git commit -m "feat: ..."
git push
```

### 提交规范
```bash
feat(scope): 新增内容 by @author
docs(scope): 文档更新 by @author
fix(scope): 修正错误 by @author
refactor(scope): 重构知识 by @author
```

## 📈 最佳实践

- ⏰ **每天工作前**: `git pull` 获取最新知识
- 📝 **重要对话后**: 立即用脚本捕获记录
- 📊 **每周整理**: 提炼对话到主题文档
- 🗂️ **每月归档**: 整理过时内容
- 🔍 **随时查询**: 利用搜索功能快速定位

## 🌟 示例内容

已包含2篇完整的对话记录示例：

1. **[具身智能企业调研](./conversations/2026-01/embodied-ai-research.md)**
   - 国内外主要企业分析
   - 行业趋势总结
   - 技术路线对比

2. **[Git共享记忆系统设计](./conversations/2026-01/git-shared-memory-design.md)**
   - 系统架构设计
   - 技术实现细节
   - 工作流程说明

## 🚧 路线图

- [x] 基础文件结构
- [x] Web可视化界面
- [x] 自动化捕获脚本
- [x] Git集成和工作流
- [ ] 配置远程Git仓库
- [ ] 开发VSCode插件
- [ ] 实现知识图谱可视化
- [ ] 移动端适配
- [ ] AI辅助知识整理

## 📞 使用帮助

在Claude Code中随时询问：
```
"如何使用团队记忆库？"
"帮我记录今天的对话"
"查看团队关于XX的讨论"
```

## 📄 许可证

MIT License - 自由使用和修改

## 🙏 致谢

感谢Claude Code提供强大的上下文管理功能，让这个系统成为可能。

---

**当前位置**: `C:\Users\lijun13\team-memory-repo\`

**立即开始**: 双击打开 [index.html](./index.html) 查看效果 🚀

**需要帮助**: 查看 [QUICKSTART.md](./QUICKSTART.md) 或 [DEMO.md](./DEMO.md)
