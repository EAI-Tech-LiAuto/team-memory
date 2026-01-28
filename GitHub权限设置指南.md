# GitHub权限设置指南

## 📋 问题：团队成员无法推送内容

**错误提示可能是**：
```
remote: Permission to EAI-Tech-LiAuto/team-memory.git denied
fatal: unable to access 'https://github.com/EAI-Tech-LiAuto/team-memory.git/': The requested URL returned error: 403
```

---

## ✅ 解决方案

### 方案1：添加协作者（Collaborators）- 推荐 ⭐⭐⭐⭐⭐

**适用于**: 团队成员较少（<10人）

#### 步骤：

1. **打开仓库设置**
   - 访问：https://github.com/EAI-Tech-LiAuto/team-memory
   - 点击右上角 `Settings`（设置）

2. **添加协作者**
   - 左侧菜单找到 `Collaborators and teams`（协作者和团队）
   - 点击 `Add people`（添加人员）按钮

3. **输入GitHub用户名**
   - 输入团队成员的GitHub用户名或邮箱
   - 点击 `Add XXX to this repository`

4. **选择权限级别**
   - **Write**（写入）- 推荐：可以push代码，不能改设置
   - **Maintain**（维护）- 可以管理issues和PR
   - **Admin**（管理员）- 完全控制（慎用）

5. **团队成员接受邀请**
   - 成员会收到邮件邀请
   - 点击邮件中的链接接受邀请
   - 或访问：https://github.com/EAI-Tech-LiAuto/team-memory/invitations

#### 批量添加：

如果要添加多个人，重复步骤2-4即可。

---

### 方案2：使用GitHub组织团队（Teams）- 大团队推荐 ⭐⭐⭐⭐

**适用于**: 团队成员较多（>10人），或有多个项目需要统一管理

#### 前提条件：
仓库必须在组织（Organization）下，而不是个人账号下。

#### 步骤：

1. **创建团队**
   - 访问：https://github.com/orgs/EAI-Tech-LiAuto/teams
   - 点击 `New team`
   - 输入团队名称：如 `Robotics-Contributors`
   - 选择可见性：`Visible`（团队成员可见）

2. **添加团队成员**
   - 进入团队页面
   - 点击 `Members` → `Add a member`
   - 输入GitHub用户名添加

3. **为团队分配仓库权限**
   - 回到仓库：https://github.com/EAI-Tech-LiAuto/team-memory
   - 点击 `Settings` → `Collaborators and teams`
   - 点击 `Add teams`
   - 选择刚创建的团队
   - 选择权限级别：`Write`

4. **完成！**
   - 团队所有成员自动获得仓库写入权限
   - 新加入团队的成员自动获得权限

---

### 方案3：设置仓库为公开可写（不推荐）❌

**为什么不推荐**: 任何人都能修改，不安全。

---

## 🔐 权限级别说明

| 权限级别 | 能做什么 | 适合谁 |
|---------|---------|--------|
| **Read** | 查看、克隆、下载 | 外部访客 |
| **Triage** | 管理issues和PR（不能push代码） | 项目管理员 |
| **Write** | ✅ Push代码、创建分支、管理issues | ✅ **团队贡献者（推荐）** |
| **Maintain** | Write权限 + 管理仓库设置（不含删除） | 核心维护者 |
| **Admin** | 完全控制，包括删除仓库 | 项目负责人 |

---

## 📝 操作清单（给仓库管理员）

### 如果你是仓库创建者/管理员：

**一次性设置（5-10分钟）**：

```
□ 1. 访问 https://github.com/EAI-Tech-LiAuto/team-memory/settings/access
□ 2. 点击 "Add people"
□ 3. 添加以下成员（GitHub用户名）：
   □ 李君: _________
   □ 郎博: _________
   □ 朱俊蓉: _________
   □ 其他成员: _________
□ 4. 为每个人选择 "Write" 权限
□ 5. 通知团队成员检查邮箱并接受邀请
□ 6. 测试：让一个成员尝试 push 代码
```

---

## 🎯 团队成员需要做什么

### 步骤1: 确认收到邀请

**方法A: 邮箱查看**
- 查找GitHub发送的邀请邮件
- 标题类似：`You've been invited to collaborate on...`
- 点击邮件中的 `View invitation` 按钮

**方法B: 直接访问**
- 访问：https://github.com/EAI-Tech-LiAuto/team-memory/invitations
- 登录GitHub账号
- 点击 `Accept invitation`（接受邀请）

### 步骤2: 配置Git凭证（重要！）

**如果之前clone过仓库，需要更新凭证**：

#### Windows用户：
1. 打开 `控制面板` → `凭据管理器` → `Windows凭据`
2. 找到 `git:https://github.com` 相关的凭据
3. 删除或编辑，更新为你的GitHub用户名和密码

#### Mac用户：
```bash
git config --global credential.helper osxkeychain
```

#### Linux用户：
```bash
git config --global credential.helper cache
```

#### 使用SSH（推荐）：

**为什么用SSH？**
- 不需要每次输入密码
- 更安全
- 更方便

**设置步骤**：

1. 生成SSH密钥：
```bash
ssh-keygen -t ed25519 -C "你的邮箱@lixiang.com"
```
按3次回车（使用默认设置）

2. 复制公钥：
```bash
# Windows
cat ~/.ssh/id_ed25519.pub | clip

# Mac
cat ~/.ssh/id_ed25519.pub | pbcopy

# Linux
cat ~/.ssh/id_ed25519.pub
```

3. 添加到GitHub：
   - 访问：https://github.com/settings/keys
   - 点击 `New SSH key`
   - 粘贴公钥
   - 点击 `Add SSH key`

4. 更新仓库URL（如果之前用的HTTPS）：
```bash
cd team-memory
git remote set-url origin git@github.com:EAI-Tech-LiAuto/team-memory.git
```

5. 测试连接：
```bash
ssh -T git@github.com
# 应该看到：Hi username! You've successfully authenticated...
```

### 步骤3: 测试推送权限

```bash
cd team-memory
git pull
echo "测试文件" > test.txt
git add test.txt
git commit -m "测试权限"
git push
```

**看到什么算成功？**
- 显示 `Writing objects: 100%...`
- 显示 `To https://github.com/...`
- 显示 `main -> main`

**如果失败？**
- 检查是否接受了邀请
- 检查Git凭证是否正确
- 尝试重新克隆仓库

---

## 🆘 常见问题

### Q1: 我没有收到邀请邮件？

**解决方法**：
1. 检查垃圾邮件文件夹
2. 直接访问：https://github.com/EAI-Tech-LiAuto/team-memory/invitations
3. 让管理员重新发送邀请

### Q2: 提示 403 forbidden？

**原因**: 凭证不对或没有权限

**解决方法**：
1. 确认已接受邀请
2. 清除Git凭证：
```bash
# Windows
git config --global --unset credential.helper

# Mac/Linux
git credential-osxkeychain erase
```
3. 重新push，输入正确的用户名和密码（或token）

### Q3: 什么是Personal Access Token？

GitHub现在推荐用Token代替密码。

**创建Token**：
1. 访问：https://github.com/settings/tokens
2. 点击 `Generate new token (classic)`
3. 勾选 `repo` 权限
4. 生成并复制token（只显示一次！）
5. Push时用token代替密码

### Q4: 每次push都要输入密码？

**解决方法**：使用SSH（见上文）或配置凭证存储：

```bash
# 永久存储凭证（不安全，慎用）
git config --global credential.helper store

# 临时缓存（15分钟）
git config --global credential.helper cache
```

---

## 📞 需要帮助？

1. **查看详细错误**：
```bash
GIT_CURL_VERBOSE=1 git push
```

2. **联系仓库管理员**：
   - 确认是否已添加你为协作者
   - 确认你的GitHub用户名是否正确

3. **GitHub文档**：
   - https://docs.github.com/cn/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/managing-teams-and-people-with-access-to-your-repository

---

## ✅ 权限设置完成检查清单

管理员：
- [ ] 所有团队成员已添加为协作者（Write权限）
- [ ] 通知所有成员检查邮箱
- [ ] 至少一位成员测试push成功

团队成员：
- [ ] 接受了邀请
- [ ] 配置了Git凭证（或SSH）
- [ ] 测试push成功
- [ ] 能在网站上看到自己的提交

---

**完成后，每个人都能轻松分享知识了！** 🎉
