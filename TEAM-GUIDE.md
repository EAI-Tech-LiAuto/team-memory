# 👥 团队成员快速入门指南

欢迎加入团队共享记忆库！这个5分钟指南将帮你快速上手。

## 🎯 你能做什么？

- 📖 **浏览**：查看团队所有与Claude Code的对话记录
- 🔍 **搜索**：快速找到相关的技术讨论和解决方案
- ✍️ **贡献**：将你的重要对话记录并分享给团队
- 🤝 **协作**：基于他人的经验继续工作

## 🚀 3步开始使用

### Step 1: 获取访问权限

#### 方式A: 浏览Web界面（只读）
```
直接访问：https://your-org.github.io/team-memory/
（管理员会提供具体链接）
```

#### 方式B: 克隆仓库（读写）
```bash
# 克隆到本地
git clone https://github.com/your-org/team-memory.git ~/team-memory-repo
cd ~/team-memory-repo

# 配置你的Git信息
git config user.name "Your Name"
git config user.email "your.email@company.com"
```

### Step 2: 浏览现有知识

#### 通过Web界面
1. 打开浏览器访问团队记忆库网址
2. 使用搜索框查找感兴趣的主题
3. 点击卡片查看完整对话

#### 通过文件系统
```bash
cd ~/team-memory-repo

# 查看所有对话
ls conversations/2026-01/

# 阅读特定对话
cat conversations/2026-01/embodied-ai-research.md

# 搜索关键词
grep -r "架构" conversations/
```

### Step 3: 记录你的对话

#### 3.1 与Claude Code对话时
```bash
# 在你的项目中引用团队记忆
cd ~/my-project
cat > .claude.local.md << 'EOF'
# 项目上下文

## 团队记忆引用
参考: ~/team-memory-repo/

相关主题:
- [认证系统设计](~/team-memory-repo/conversations/2026-01/auth-design.md)

## 当前任务
[你的任务描述]
EOF

# 启动Claude Code
claude code
```

#### 3.2 对话结束后记录
```bash
cd ~/team-memory-repo

# Windows
scripts\capture.bat my-topic-name

# Mac/Linux
./scripts/capture.sh my-topic-name

# 脚本会创建模板文件并打开编辑器
# 填写以下内容：
# - 会话背景
# - 关键发现
# - 代码示例
# - 后续行动
```

#### 3.3 提交并分享
```bash
# 查看修改
git status

# 添加文件
git add .

# 提交（使用规范格式）
git commit -m "feat(topic): 添加XX讨论 by @yourname"

# 推送到远程
git push
```

## 📝 日常工作流程

### 每天早上
```bash
cd ~/team-memory-repo
git pull  # 获取团队最新知识
```

### 工作中
- 遇到问题先搜索团队记忆库
- 在Web界面查找相关讨论
- 基于已有知识继续工作

### 重要对话后
```bash
cd ~/team-memory-repo
./scripts/capture.bat topic-name
# 编辑、提交、推送
```

### 每周五下午（可选）
- 整理本周的对话记录
- 提炼精华到主题文档
- 更新相关的决策记录

## 💡 最佳实践

### 什么值得记录？
✅ **应该记录**：
- 重要技术决策
- 复杂问题解决方案
- 架构设计讨论
- 技术调研成果

❌ **不需要记录**：
- 简单语法查询
- 临时一次性任务
- 个人学习笔记

### 如何写好记录？

**好的记录**：
```markdown
## 会话背景
我们需要选择一个认证方案，考虑了JWT和Session两种方式。

## 关键发现
JWT更适合我们的微服务架构，因为：
1. 无状态，便于横向扩展
2. 支持跨域
3. 移动端友好

## 代码示例
[具体的代码实现]

## 后续行动
- [ ] 实现JWT生成和验证
- [ ] 添加refresh token机制
```

**避免的写法**：
```markdown
今天和Claude聊了聊JWT，感觉不错。
```

### 提交规范

```bash
# 格式: <type>(<scope>): <subject> by @author

feat(auth): 添加JWT认证方案讨论 by @alice
docs(api): 更新API文档说明 by @bob
fix(debug): 修正Redis连接问题解决方案 by @charlie
```

## 🔍 常用操作

### 搜索对话
```bash
# 搜索包含"性能"的对话
cd ~/team-memory-repo
grep -r "性能" conversations/

# 搜索特定作者的对话
grep -r "author: alice" conversations/

# 搜索特定标签
grep -r "tags:.*research" conversations/
```

### 查看历史
```bash
# 查看最近5次提交
git log -5 --oneline

# 查看某个文件的修改历史
git log -p conversations/2026-01/auth-design.md

# 查看谁修改了某行
git blame conversations/2026-01/auth-design.md
```

### 启动本地Web服务器
```bash
cd ~/team-memory-repo

# Windows
scripts\serve.bat

# Mac/Linux
./scripts/serve.sh

# 浏览器访问: http://localhost:8000
```

## ❓ 常见问题

### Q1: 我不会用Git怎么办？
**A**: 可以只使用Web界面浏览，让管理员帮你提交记录。或者学习基础的Git命令：
```bash
git pull   # 获取最新
git add .  # 添加文件
git commit -m "message"  # 提交
git push   # 推送
```

### Q2: 我的对话包含敏感信息怎么办？
**A**: 不要提交敏感信息到团队库。可以：
- 使用个人的`.claude.local.md`记录（不提交Git）
- 或对敏感部分打码后再记录

### Q3: Web界面没有显示我的新记录？
**A**:
- 检查是否`git push`成功
- 如果用GitHub Pages，等待1-2分钟自动部署
- 刷新浏览器（Ctrl+F5强制刷新）

### Q4: 和别人的提交冲突了怎么办？
**A**:
```bash
git pull  # 先拉取最新代码
# 如果有冲突，手动解决冲突
git add .
git commit -m "merge: 解决冲突"
git push
```

### Q5: 可以删除别人的记录吗？
**A**: 技术上可以，但不建议。如果发现错误：
- 提交一个更正的版本
- 或在Git中revert特定提交
- 最好先和团队讨论

## 🆘 需要帮助？

- 📖 查看完整文档：[README.md](./README.md)
- 🚀 快速开始：[QUICKSTART.md](./QUICKSTART.md)
- 🤝 协作指南：[COLLABORATION.md](./COLLABORATION.md)
- 🎬 详细演示：[DEMO.md](./DEMO.md)

或在Claude Code中问：
```
"如何使用团队记忆库？"
"帮我记录今天的对话"
```

## 📞 联系方式

- 技术问题：联系管理员 @admin
- Git问题：参考 [Git简明指南](https://rogerdudler.github.io/git-guide/index.zh.html)
- 建议反馈：提交Issue或直接联系团队

---

**欢迎来到团队！让我们一起积累集体智慧 🚀**

**下一步**：
1. ✅ 浏览Web界面
2. ✅ 克隆仓库到本地
3. ✅ 记录你的第一个对话
