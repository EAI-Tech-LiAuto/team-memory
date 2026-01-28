# 团队共享记忆库

这是我们团队与Claude Code交流的集体记忆中心。每次重要对话的精华都会被捕获到这里，形成团队的知识资产。

## 📚 快速导航

### 最近更新
- 2026-01-28: 家用机器人全球领先企业分析 - [查看详情](./conversations/2026-01/home-robot-industry-analysis.md)
- 2026-01-27: 具身智能企业调研 - [查看详情](./conversations/2026-01/embodied-ai-research.md)
- 2026-01-27: Git共享记忆系统设计 - [查看详情](./conversations/2026-01/git-shared-memory-design.md)

### 按主题浏览
- [📐 架构决策](./topics/architecture/) - 系统设计和技术选型
- [⚙️ 功能实现](./topics/features/) - 具体功能的实现细节
- [🐛 调试经验](./topics/debugging/) - 常见问题和解决方案
- [🔬 研究调研](./topics/research/) - 技术调研和行业分析

### 重要决策 (ADR)
- [决策记录索引](./decisions/README.md)

### 工作流程
- [日常开发流程](./workflows/daily-development.md)
- [代码审查流程](./workflows/code-review.md)

## 🚀 快速开始

### 新成员入门
1. 克隆这个仓库到本地
2. 阅读本文件了解整体结构
3. 浏览 `decisions/` 了解关键决策
4. 查看最近的对话记录
5. 开始使用！

### 日常使用
```bash
# 每天开始工作前
cd ~/team-memory-repo
git pull  # 获取团队最新知识

# 在你的项目中引用团队记忆
# 创建 .claude.local.md 并引用相关主题

# 重要对话后
./scripts/capture.sh "topic-name"
git add . && git commit -m "feat: 添加xxx讨论"
git push
```

## 📝 使用规范

### 对话记录规范
- 位置: `conversations/YYYY-MM/topic-name.md`
- 格式: YAML frontmatter + Markdown内容
- 必须字段: date, author, topic, tags

### 主题文件规范
- 持续累积相关知识
- 包含代码示例和最佳实践
- 引用相关的对话记录
- 定期更新和重构

### 提交规范
```bash
feat(scope): 简短描述 by @author     # 新增内容
docs(scope): 简短描述 by @author     # 文档更新
fix(scope): 简短描述 by @author      # 修正错误
refactor(scope): 简短描述 by @author # 重构知识结构
```

## 🎯 核心价值

1. **集体智慧** - 每个人的经验都为团队贡献价值
2. **知识可追溯** - 通过Git完整保留讨论历史
3. **快速查找** - 结构化组织，快速定位所需信息
4. **新人友好** - 新成员快速了解项目历史和决策
5. **持续进化** - 知识随项目发展不断完善

## 🔍 搜索和查询

与Claude Code交互时可以这样问：
```
"在团队记忆库中搜索关于认证的讨论"
"总结我们团队对微服务架构的所有决策"
"查找上次关于性能优化的对话"
```

## 📊 统计信息

- 对话记录: 3 篇
- 主题文档: 1 篇
- 架构决策: 0 个
- 贡献者: 1 人

---

💡 **提示**: 使用 `/init` 命令可以让Claude Code帮你创建标准的项目CLAUDE.md文件
