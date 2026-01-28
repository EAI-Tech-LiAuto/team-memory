# 📜 脚本说明文档

本目录包含团队知识库的自动化脚本，让分享知识变得简单快捷。

---

## 🚀 核心脚本

### 1. `add-conversation.bat` / `add-conversation.sh`

**用途**: 一键添加对话记录到知识库

**适用系统**:
- `.bat` - Windows
- `.sh` - Mac/Linux

**功能特性**:
- ✅ 交互式问答，引导你填写信息
- ✅ 自动创建规范的markdown文件
- ✅ 自动打开编辑器让你填写内容
- ✅ **自动更新网页** - 扫描文件并更新index.html
- ✅ 自动Git提交和推送
- ✅ 错误处理和自动修复

**使用方法**:

Windows:
```bash
# 方法1: 双击运行
双击 scripts/add-conversation.bat

# 方法2: 命令行运行
cd team-memory
scripts\add-conversation.bat
```

Mac/Linux:
```bash
cd team-memory
./scripts/add-conversation.sh
```

**操作流程**:
1. 同步最新内容 (git pull)
2. 填写基本信息（姓名、主题、描述、标签）
3. 自动创建markdown文件并打开编辑器
4. 编辑完成后保存关闭
5. **自动更新网页内容** 🆕
6. 自动提交并推送到GitHub

**预期时间**: 2-3分钟

---

### 2. `update-index.py`

**用途**: 自动扫描所有对话文件并更新index.html

**功能**:
- 扫描 `conversations/` 目录下所有 `.md` 文件
- 解析YAML frontmatter（日期、作者、标签等）
- 提取摘要内容
- 自动生成对话卡片HTML
- 自动生成时间线HTML
- 更新统计数字（对话数、贡献者数）

**依赖**:
```bash
pip install pyyaml
```

**使用方法**:
```bash
# 在仓库根目录运行
python scripts/update-index.py
```

**何时使用**:
- 通常不需要手动运行，`add-conversation` 脚本会自动调用
- 如果手动添加了markdown文件，可以运行此脚本更新网页
- 如果网页显示不对，可以重新运行此脚本修复

**输出示例**:
```
============================================================
🔄 自动更新 index.html
============================================================

📁 仓库路径: C:\Users\lijun13\team-memory-repo

📖 扫描对话文件...
✓ 已读取: conversations/2026-01/home-robot-one-month-plan.md
✓ 已读取: conversations/2026-01/one-month-accelerated-plan.md
✓ 已读取: conversations/2026-01/home-service-robot-research.md
✓ 已读取: conversations/2026-01/家用及工厂机器人差异.md

找到 4 个对话文件

📝 更新 index.html...

✅ 成功更新 index.html
   - 对话记录: 4 篇
   - 贡献者: 3 人

============================================================
✨ 完成！网页内容已自动更新
============================================================
```

---

### 3. `manual-update-web.bat`

**用途**: 手动触发网页更新（如果自动更新失败）

**使用场景**:
- `add-conversation` 脚本中的自动更新失败
- 你手动编辑了对话文件，需要刷新网页
- 网页显示的内容不是最新的

**使用方法**:
```bash
# Windows: 双击运行
双击 scripts/manual-update-web.bat

# 或命令行
cd team-memory
scripts\manual-update-web.bat
```

**功能**:
1. 运行 `update-index.py`
2. 询问是否提交到GitHub
3. 如果确认，自动 `git add` + `git commit` + `git push`

---

### 4. `daily-sync.bat`

**用途**: 每日同步团队最新内容

**使用方法**:
```bash
# 双击运行
双击 scripts/daily-sync.bat
```

**功能**:
- 检查是否有远程更新
- 如果有，自动pull最新内容
- 显示更新的文件列表

**建议**: 每天早上第一件事就运行此脚本

---

## 🔧 工作原理

### 自动更新网页的流程

```
用户添加markdown文件
         ↓
add-conversation脚本调用
         ↓
update-index.py执行
         ↓
    1. 扫描conversations目录
    2. 读取每个.md文件
    3. 解析YAML frontmatter
    4. 提取日期、作者、标签、摘要
         ↓
    5. 生成HTML卡片代码
    6. 生成时间线代码
    7. 替换index.html中对应部分
    8. 更新统计数字
         ↓
index.html已更新
         ↓
git add + commit + push
         ↓
GitHub Pages自动部署
         ↓
1-2分钟后网站更新完成 ✨
```

### markdown文件格式要求

每个对话文件必须包含YAML frontmatter:

```yaml
---
date: 2026-01-28
author: 你的名字
topic: 对话主题
tags: [标签1, 标签2, 标签3]
related_files: []
status: completed
---

# 对话主题

## 会话背景
这里写背景...

## 关键发现
这里写要点...
```

**必需字段**:
- `date`: 日期（YYYY-MM-DD格式）
- `author`: 作者名字
- `topic`: 主题标题
- `tags`: 标签数组

**可选字段**:
- `related_files`: 相关文件列表
- `status`: 状态（completed/draft/archived）
- `summary`: 自定义摘要（如果不提供，会自动提取）

---

## 📋 常见问题

### Q1: 运行脚本提示"Python不是内部或外部命令"

**解决**:
1. 安装Python: https://www.python.org/downloads/
2. 安装时**务必勾选** "Add Python to PATH"
3. 安装 `pyyaml`: `pip install pyyaml`
4. 重新打开命令行窗口

### Q2: 自动更新网页失败了怎么办？

**解决**:
```bash
# 手动运行更新脚本
python scripts/update-index.py

# 如果成功，提交更新
git add index.html
git commit -m "chore: 更新网页索引"
git push
```

### Q3: 我添加了文件但网页没显示

**可能原因**:
1. markdown文件缺少YAML frontmatter
2. frontmatter格式不正确
3. 文件不在 `conversations/` 目录下

**解决**:
1. 检查文件格式是否正确
2. 手动运行 `python scripts/update-index.py` 看错误信息
3. 修复后重新运行

### Q4: 能否不用Python，用其他语言？

可以，但Python最简单：
- 跨平台（Windows/Mac/Linux都支持）
- 语法简单，易于修改
- 有现成的YAML解析库

如果团队有其他需求，可以用Node.js或其他语言重写 `update-index.py`。

### Q5: 为什么不用GitHub Actions自动更新？

也可以！未来可以改进为：
- 在GitHub仓库中配置Actions
- 当有新commit时自动运行Python脚本
- 自动提交更新后的index.html

目前方案的优点：
- 本地即时反馈
- 不依赖GitHub Actions配额
- 更容易调试和修改

---

## 🎯 最佳实践

### 对于新手

1. **只用自动化脚本**
   - 双击 `add-conversation.bat`
   - 按提示操作
   - 完全不需要了解Git命令

2. **每天开始前**
   - 双击 `daily-sync.bat`
   - 获取团队最新内容

3. **遇到问题**
   - 先看脚本输出的错误信息
   - 查看本README的常见问题
   - 联系技术同事

### 对于进阶用户

1. **可以手动操作**
   ```bash
   # 创建文件
   vim conversations/2026-01/my-topic.md

   # 更新网页
   python scripts/update-index.py

   # 提交
   git add .
   git commit -m "feat: 添加XXX"
   git push
   ```

2. **可以修改脚本**
   - 所有脚本都有详细注释
   - 可以根据团队需求定制
   - 欢迎提交改进建议

3. **可以批量操作**
   - 一次添加多个文件
   - 统一运行 `update-index.py`
   - 批量提交

---

## 📞 需要帮助？

- 查看 [新手指南.md](../新手指南.md)
- 查看 [Git命令速查.md](../Git命令速查.md)
- 联系技术同事：李君、郎博、朱俊蓉

---

**更新日期**: 2026-01-28
**维护者**: 团队共同维护
