# 团队共享记忆库 - 使用演示指南

## 🎉 恭喜！你的团队记忆库已经创建成功

已创建的内容：
- ✅ 基础文件结构
- ✅ 2篇对话记录
- ✅ Web可视化界面
- ✅ 自动化脚本
- ✅ Git版本控制

## 📱 如何使用

### 1. 查看Web可视化界面

**方法A: 直接打开HTML文件**
```bash
# Windows
start ~/team-memory-repo/index.html

# Mac
open ~/team-memory-repo/index.html

# Linux
xdg-open ~/team-memory-repo/index.html
```

**方法B: 使用本地服务器（推荐）**
```bash
cd ~/team-memory-repo
python -m http.server 8000
# 然后在浏览器访问: http://localhost:8000
```

### 2. 捕获新的对话

**Windows:**
```bash
cd ~/team-memory-repo
scripts\capture.bat my-new-topic
```

**Mac/Linux:**
```bash
cd ~/team-memory-repo
chmod +x scripts/capture.sh
./scripts/capture.sh my-new-topic
```

### 3. 在项目中引用团队记忆

在你的项目根目录创建 `.claude.local.md`:
```markdown
# 本地开发上下文

## 团队记忆引用
参考: ~/team-memory-repo/

相关主题:
- [具身智能调研](~/team-memory-repo/conversations/2026-01/embodied-ai-research.md)
- [知识管理系统](~/team-memory-repo/conversations/2026-01/git-shared-memory-design.md)

## 当前任务
[你的工作内容]
```

### 4. 与Claude Code交互

启动Claude Code后，可以这样问：
```
"查看团队记忆库中关于具身智能的调研"
"总结团队对知识管理系统的设计思路"
"在团队记忆库中搜索关于架构的讨论"
```

### 5. 提交到Git

```bash
cd ~/team-memory-repo

# 查看状态
git status

# 添加文件
git add .

# 提交
git commit -m "feat(topic): 添加XX讨论 by @yourname"

# 推送到远程（需要先配置远程仓库）
# git remote add origin <your-repo-url>
# git push -u origin master
```

## 🔍 常用操作示例

### 搜索对话记录
```bash
cd ~/team-memory-repo

# 搜索包含"架构"的对话
grep -r "架构" conversations/

# 搜索特定作者的对话
grep -r "author: alice" conversations/
```

### 查看最近更新
```bash
cd ~/team-memory-repo
git log -5 --oneline
```

### 查看特定文件的历史
```bash
cd ~/team-memory-repo
git log -p conversations/2026-01/embodied-ai-research.md
```

## 🌐 分享给团队成员

### 方法1: GitHub/GitLab
```bash
# 创建远程仓库后
git remote add origin <your-repo-url>
git push -u origin master

# 团队成员克隆
git clone <your-repo-url> ~/team-memory-repo
```

### 方法2: 共享网络目录
将 `~/team-memory-repo` 放到团队共享的网络驱动器

### 方法3: 部署Web界面
将 `index.html` 部署到内部服务器，团队成员通过浏览器访问

## 📊 Web界面功能

打开 `index.html` 后，你可以：
- 📈 查看统计数据（对话数、主题数、贡献者）
- 🔍 搜索对话记录
- 🏷️ 按标签过滤
- ⏱️ 查看时间线
- 📑 浏览主题分类
- 🔗 快速导航到相关文档

## 💡 最佳实践

1. **每天工作前**: `git pull` 获取最新知识
2. **重要对话后**: 使用 `capture.bat/sh` 快速记录
3. **每周回顾**: 整理和补充主题文档
4. **定期维护**: 归档过时内容，更新索引

## 🚀 下一步

- [ ] 配置Git远程仓库
- [ ] 邀请团队成员克隆仓库
- [ ] 建立团队使用规范
- [ ] 定期组织知识分享会
- [ ] 开发更多自动化工具

## 🆘 需要帮助？

在Claude Code中问：
```
"如何使用团队记忆库？"
"团队记忆库的最佳实践是什么？"
"帮我记录今天的对话到团队记忆库"
```

---

**当前状态**: ✅ 已初始化，可以开始使用！

**文件位置**:
- 记忆库: `~/team-memory-repo/`
- Web界面: `~/team-memory-repo/index.html`
- 演示项目: `~/my-demo-project/`
