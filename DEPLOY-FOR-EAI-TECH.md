# 🚀 部署步骤 - 为 EAI-Tech-LiAuto

你的永久链接将是：`https://eai-tech-liauto.github.io/team-memory/`

---

## 第1步：配置Git用户信息 ⏱️ 1分钟

打开命令行（CMD 或 PowerShell 或 Git Bash），运行以下命令：

```bash
git config --global user.name "EAI-Tech-LiAuto"
git config --global user.email "你的邮箱@example.com"
```

**注意**：把 `你的邮箱@example.com` 替换成你注册GitHub时用的邮箱。

**示例**：
```bash
git config --global user.name "EAI-Tech-LiAuto"
git config --global user.email "admin@lixiang.com"
```

运行后，验证一下：
```bash
git config --global user.name
git config --global user.email
```

应该能看到你刚才设置的信息。

---

## 第2步：在GitHub创建仓库 ⏱️ 2分钟

### 2.1 打开GitHub
在浏览器访问：https://github.com/new

（或者：GitHub首页 → 点击右上角 `+` → 选择 `New repository`）

### 2.2 填写仓库信息

```
Repository name (仓库名称):
┌─────────────────────┐
│ team-memory         │  ← 输入这个
└─────────────────────┘

Description (描述，可选):
┌────────────────────────────────────────┐
│ 团队共享记忆库 - 与Claude Code的对话记录 │
└────────────────────────────────────────┘

访问权限：
⚪ Public  ← 选这个（公开，任何人可访问）
⚪ Private（私有，需要权限才能访问）

初始化选项：
❌ 不要勾选 "Add a README file"
❌ 不要选择 ".gitignore"
❌ 不要选择 "license"
```

### 2.3 创建仓库
点击绿色按钮：**Create repository**

### 2.4 记下仓库地址
创建后会看到一个页面，上面有你的仓库地址：
```
https://github.com/EAI-Tech-LiAuto/team-memory.git
```

**暂时不要关闭这个页面！**

---

## 第3步：推送代码到GitHub ⏱️ 3分钟

在命令行中运行以下命令：

```bash
# 进入项目目录
cd ~/team-memory-repo

# 关联远程仓库
git remote add origin https://github.com/EAI-Tech-LiAuto/team-memory.git

# 确认分支名为main
git branch -M main

# 推送代码
git push -u origin main
```

### 如果提示需要登录

会弹出登录窗口，或命令行提示输入：
```
Username: EAI-Tech-LiAuto
Password: （这里要输入Personal Access Token，不是密码）
```

### 如何获取Personal Access Token？

**如果推送时提示需要token**：

1. 打开 https://github.com/settings/tokens
2. 点击 **Generate new token** → **Generate new token (classic)**
3. 设置：
   - Note (备注): `team-memory-deploy`
   - Expiration (过期时间): 选择 `No expiration`（永不过期）
   - 勾选权限：**repo**（勾选这个即可）
4. 点击底部绿色按钮：**Generate token**
5. **复制生成的token**（格式：`ghp_xxxxxxxxxxxx`）
   - ⚠️ 只显示一次，关闭后无法再看到，请保存好
6. 回到命令行，输入这个token作为密码

### 推送成功的标志

```
Enumerating objects: 50, done.
Counting objects: 100% (50/50), done.
...
To https://github.com/EAI-Tech-LiAuto/team-memory.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

看到这样的输出就成功了！ ✅

---

## 第4步：启用GitHub Pages ⏱️ 2分钟

### 4.1 打开仓库设置
在浏览器访问：
```
https://github.com/EAI-Tech-LiAuto/team-memory
```

点击顶部菜单的 **Settings**（设置）

### 4.2 找到Pages设置
- 左侧菜单向下滚动
- 找到 **Pages**（在 "Code and automation" 部分）
- 点击进入

### 4.3 配置Pages
在 **Build and deployment** 部分：

```
Source (源):
┌──────────────────────────┐
│ Deploy from a branch     │ ← 选这个
└──────────────────────────┘

Branch (分支):
┌──────┐  ┌────────┐
│ main │  │ /(root)│  ← 选这两个
└──────┘  └────────┘
```

点击 **Save**（保存）

### 4.4 等待部署
页面会显示：
```
🟡 Your site is ready to be published at https://eai-tech-liauto.github.io/team-memory/
```

或者
```
🟡 GitHub Pages is currently building your site...
```

**等待1-2分钟**，刷新页面，会变成：
```
✅ Your site is live at https://eai-tech-liauto.github.io/team-memory/
```

---

## 第5步：测试访问 ⏱️ 1分钟

### 5.1 打开你的永久链接

在浏览器新标签打开：
```
https://eai-tech-liauto.github.io/team-memory/
```

### 5.2 你应该看到

✅ 精美的紫色渐变背景
✅ 标题"🧠 团队共享记忆库"
✅ **绿色横幅**："🚀 第一次使用？"
✅ 统计卡片：2篇对话、1个主题...
✅ 对话卡片：具身智能调研、Git共享记忆系统设计

### 5.3 测试使用指南

点击绿色横幅上的 **"查看使用指南"** 按钮

应该进入一个新页面，显示：
```
🚀 3分钟上手指南

这是什么？
→ 团队知识库...

你的角色：
🔍 我只想看看
✍️ 我想贡献内容
```

---

## 🎉 部署成功！

如果你看到了上面的内容，恭喜你！部署完成！

### 你的永久链接

```
https://eai-tech-liauto.github.io/team-memory/
```

这个链接：
- ✅ 永久有效
- ✅ 可以分享给团队所有人
- ✅ 每次push代码后，1-2分钟自动更新
- ✅ 包含完整的使用指南

### 分享给团队

复制以下内容发给团队：

```
📧 团队成员们好！

我们的团队知识库上线了 🎉

🌐 访问地址：https://eai-tech-liauto.github.io/team-memory/

这是什么？
保存我们与Claude Code重要对话的地方，
所有人的经验都在这里，随时查阅。

怎么用？
→ 打开链接直接浏览
→ 点击绿色"使用指南"按钮，3分钟学会
→ 小白也能轻松使用

想贡献内容？
→ 查看使用指南，3步教你记录对话

有问题随时问我！
```

---

## 🔄 以后如何更新内容

当你有新的对话要记录时：

```bash
# 1. 进入项目
cd ~/team-memory-repo

# 2. 获取最新代码
git pull

# 3. 记录新对话
scripts\capture.bat my-new-topic

# 4. 编辑生成的文件，填写内容...

# 5. 提交并推送
git add .
git commit -m "feat: 添加XX讨论 by @yourname"
git push
```

**1-2分钟后，网页自动更新！** ✨

---

## ❓ 常见问题

### Q1: 推送时要求输入密码

A: 输入你的Personal Access Token（不是密码）

### Q2: 链接打开是404

A:
- 等待2-5分钟再试
- 检查Pages设置是否正确
- 强制刷新浏览器（Ctrl+F5）

### Q3: 网页没有更新

A:
- 确认代码已推送（`git log -1`查看）
- 等待1-2分钟
- 强制刷新浏览器（Ctrl+F5）

### Q4: 忘记Token了

A: 在 https://github.com/settings/tokens 重新生成一个

---

准备好开始了吗？从第1步开始执行吧！有问题随时告诉我 🚀
