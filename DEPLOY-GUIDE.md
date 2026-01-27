# 🚀 GitHub部署完整指南（手把手教程）

## 📋 前置准备

### 你需要：
- ✅ 一个GitHub账号（如果没有，去 https://github.com 注册）
- ✅ 本地代码已准备好（在 `C:\Users\lijun13\team-memory-repo\`）

---

## 🎯 5步部署流程（10分钟完成）

### 第1步：配置Git身份信息（只需一次）⏱️ 1分钟

打开命令行，运行：

```bash
git config --global user.name "你的名字"
git config --global user.email "你的邮箱@example.com"
```

**示例**：
```bash
git config --global user.name "张三"
git config --global user.email "zhangsan@company.com"
```

### 第2步：在GitHub创建仓库 ⏱️ 2分钟

1. **打开浏览器**，访问 https://github.com

2. **登录你的账号**

3. **创建新仓库**
   - 点击右上角的 `+` 号
   - 选择 `New repository`（新建仓库）

4. **填写仓库信息**
   ```
   Repository name（仓库名）: team-memory
   Description（描述）: 团队共享记忆库 - 与Claude Code的对话记录

   ⚪ Public（公开）  或  ⚪ Private（私有，需GitHub Pro）

   ❌ 不要勾选 "Initialize this repository with a README"
   ❌ 不要添加 .gitignore
   ❌ 不要添加 license
   ```

5. **点击绿色按钮**：`Create repository`（创建仓库）

6. **记下你的仓库地址**
   ```
   会看到类似这样的地址：
   https://github.com/你的用户名/team-memory.git
   ```

### 第3步：推送代码到GitHub ⏱️ 3分钟

打开命令行，运行以下命令：

```bash
# 1. 进入项目目录
cd ~/team-memory-repo

# 2. 关联远程仓库（替换成你的仓库地址）
git remote add origin https://github.com/你的用户名/team-memory.git

# 3. 检查分支名（可能是main或master）
git branch

# 4. 如果是master，改为main（GitHub默认用main）
git branch -M main

# 5. 推送代码
git push -u origin main
```

**如果遇到需要登录**：
- 输入你的GitHub用户名
- 输入密码（或个人访问令牌 Personal Access Token）

**注意**：GitHub现在需要用Token而不是密码。如果推送失败，需要创建Token：
1. GitHub头像 → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token → 勾选 `repo` → Generate
3. 复制生成的token（ghp_开头的字符串）
4. 推送时用这个token作为密码

**推送成功的标志**：
```
Enumerating objects: XX, done.
...
To https://github.com/你的用户名/team-memory.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

### 第4步：启用GitHub Pages ⏱️ 2分钟

1. **在浏览器中打开你的仓库**
   ```
   https://github.com/你的用户名/team-memory
   ```

2. **点击 Settings（设置）标签**
   - 在仓库页面顶部的菜单栏

3. **找到 Pages 设置**
   - 左侧菜单向下滚动
   - 找到 `Pages`（在Code and automation部分）
   - 点击进入

4. **配置Pages**
   ```
   Source（源）: Deploy from a branch
   Branch（分支）:
      - 选择 main
      - 选择 / (root)
   ```

5. **点击 Save（保存）**

6. **等待部署（1-2分钟）**
   - 页面会显示：
   ```
   ✅ Your site is published at https://你的用户名.github.io/team-memory/
   ```
   - 或者显示黄色进度条：`🟡 GitHub Pages is building your site...`
   - 等它变成绿色的 ✅

### 第5步：测试访问 ⏱️ 1分钟

1. **复制你的永久链接**
   ```
   https://你的用户名.github.io/team-memory/
   ```

2. **在浏览器新标签打开**

3. **应该看到**
   - 精美的界面
   - 绿色的使用指南横幅
   - 统计数据、对话卡片等

4. **点击绿色横幅**测试使用指南页面

---

## ✅ 部署成功检查清单

完成后，你应该：
- [ ] 能访问 `https://你的用户名.github.io/team-memory/`
- [ ] 看到精美的首页
- [ ] 看到绿色的"第一次使用？"横幅
- [ ] 能点击进入使用指南页面
- [ ] 能看到2篇示例对话记录

---

## 🎉 获得永久链接！

你的永久链接是：
```
https://你的用户名.github.io/team-memory/
```

**这个链接的特点**：
- ✅ 永久有效（只要仓库存在）
- ✅ 自动更新（push代码后1-2分钟自动部署）
- ✅ 可以分享给团队
- ✅ 包含使用指南

---

## 📤 分享给团队

复制以下消息发给团队：

```
📧 团队消息模板：

大家好！我们的团队知识库上线了 🎉

🌐 访问地址：https://你的用户名.github.io/team-memory/

这是什么？
→ 保存我们与Claude Code重要对话的地方
→ 所有人的经验都在这里，随时查阅

怎么用？
→ 打开链接就能浏览
→ 首页有绿色的"使用指南"按钮，3分钟上手
→ 小白也能轻松使用

想贡献内容？
→ 看使用指南，3步教你如何记录对话

有问题随时问我！
```

---

## 🔄 以后如何更新

当你添加新的对话记录后：

```bash
cd ~/team-memory-repo

# 1. 确保是最新代码
git pull

# 2. 记录新对话
scripts\capture.bat my-new-topic

# 3. 编辑文件...

# 4. 提交并推送
git add .
git commit -m "feat: 添加XX讨论 by @yourname"
git push
```

**1-2分钟后，网页自动更新** ✨

---

## ❓ 常见问题

### Q1: 推送时提示需要登录

**A**: GitHub需要身份验证。

**方法1：使用Personal Access Token（推荐）**
1. GitHub → Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. 勾选 `repo`
4. 生成并复制token
5. 推送时用token作为密码

**方法2：使用SSH**
1. 生成SSH密钥：`ssh-keygen -t ed25519 -C "your@email.com"`
2. 添加到GitHub：Settings → SSH and GPG keys
3. 改用SSH地址：`git remote set-url origin git@github.com:你的用户名/team-memory.git`

### Q2: Pages显示404 Not Found

**A**: 可能原因：
- 等待时间不够（等2-5分钟再试）
- 仓库是Private（需要GitHub Pro才能用Private repo的Pages）
- index.html不在根目录（检查文件位置）

**解决**：
- 刷新浏览器（Ctrl+F5）
- 检查GitHub Pages设置是否正确
- 查看仓库的Actions标签，看部署状态

### Q3: 推送失败：rejected

**A**: 远程有更新，本地代码过时

**解决**：
```bash
git pull --rebase
git push
```

### Q4: 想要私有仓库（不公开）

**A**:
- 免费账号：仓库可以Private，但Pages会公开
- GitHub Pro：仓库和Pages都可以私有
- 企业方案：使用GitLab自建服务器（完全私有）

---

## 🆘 需要帮助？

如果遇到问题：

1. **检查文件**：`ls ~/team-memory-repo`
2. **检查远程**：`git remote -v`
3. **查看状态**：`git status`
4. **查看日志**：`git log --oneline -5`

把错误信息告诉我，我会帮你解决！

---

## 📋 完整命令清单（供复制）

```bash
# 配置Git（只需一次）
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"

# 推送到GitHub
cd ~/team-memory-repo
git remote add origin https://github.com/你的用户名/team-memory.git
git branch -M main
git push -u origin main

# 以后更新时
git add .
git commit -m "你的提交信息"
git push
```

现在就开始吧！ 🚀
