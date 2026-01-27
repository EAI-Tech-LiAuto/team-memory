# 团队协作和分享方案

## 📋 概念澄清

### ❓ 对话记录是如何产生的？

**重要**：对话记录**不是自动**生成的！需要团队成员主动记录。

#### 完整流程：

1. **Alice与Claude Code对话**（30分钟）
   ```
   Alice: "帮我设计一个认证系统"
   Claude: [详细设计方案...]
   Alice: [继续讨论实现细节...]
   ```

2. **对话结束后，Alice主动记录**
   ```bash
   cd ~/team-memory-repo
   ./scripts/capture.bat auth-system-design
   # 编辑生成的markdown文件，记录关键内容
   ```

3. **Alice提交到Git**
   ```bash
   git add .
   git commit -m "feat(auth): 认证系统设计讨论 by @alice"
   git push
   ```

4. **Bob获取Alice的记录**
   ```bash
   cd ~/team-memory-repo
   git pull
   # 现在Bob可以看到Alice的对话记录
   cat conversations/2026-01/auth-system-design.md
   ```

5. **Bob基于Alice的记录继续工作**
   - 在项目中引用Alice的设计
   - 完成后也记录自己的对话
   - 提交到团队记忆库

### 🔑 关键点

- ✅ 每个人需要**主动记录**自己的对话
- ✅ 不需要记录所有对话，只记录**重要的**
- ✅ 使用`capture.bat`脚本可以快速创建模板
- ✅ 通过Git同步，所有人看到所有人的记录

---

## 🌐 团队访问方案

### 方案对比

| 方案 | 优点 | 缺点 | 适合场景 |
|-----|------|------|---------|
| **Git仓库** | 版本控制、协作友好 | 需要Git知识 | 技术团队 |
| **GitHub Pages** | 免费、自动部署、永久链接 | 公开可见 | 开源项目 |
| **内网Web服务器** | 私密、定制化 | 需要维护 | 企业内部 |
| **共享文件夹** | 最简单 | 无版本控制 | 小团队 |

---

## 🚀 推荐方案

### 方案1: GitHub + GitHub Pages（推荐⭐⭐⭐⭐⭐）

**适合**：希望有永久链接、自动部署的团队

#### Step 1: 创建GitHub仓库
```bash
# 1. 在GitHub上创建新仓库（如：team-memory）

# 2. 关联本地仓库
cd ~/team-memory-repo
git remote add origin https://github.com/your-org/team-memory.git
git branch -M main
git push -u origin main
```

#### Step 2: 启用GitHub Pages
1. 进入仓库Settings
2. 找到Pages设置
3. Source选择：`main` 分支 `/` (root)
4. 保存后获得链接：`https://your-org.github.io/team-memory/`

#### Step 3: 团队成员访问
```
浏览器访问：https://your-org.github.io/team-memory/
编辑内容：克隆仓库后提交
```

**优点**：
- ✅ 自动部署（push后自动更新网页）
- ✅ 永久链接，随时访问
- ✅ 完整的Git版本控制
- ✅ 免费

**缺点**：
- ⚠️ 默认公开（可以用private repo + GitHub Pro）

---

### 方案2: GitLab私有仓库 + Pages（企业推荐⭐⭐⭐⭐⭐）

**适合**：企业内部，需要私密性

#### Step 1: 创建GitLab私有仓库
```bash
cd ~/team-memory-repo
git remote add origin https://gitlab.company.com/team/memory.git
git push -u origin main
```

#### Step 2: 配置GitLab Pages
创建 `.gitlab-ci.yml`:
```yaml
pages:
  stage: deploy
  script:
    - mkdir .public
    - cp -r * .public
    - mv .public public
  artifacts:
    paths:
      - public
  only:
    - main
```

#### Step 3: 访问
```
内部链接：https://team.gitlab.company.com/memory/
权限控制：只有团队成员可访问
```

---

### 方案3: 简单的内网Web服务器（小团队⭐⭐⭐⭐）

**适合**：有一台内网服务器，小型团队

#### 在服务器上部署

```bash
# 克隆仓库到服务器
cd /var/www/
git clone https://github.com/your-org/team-memory.git

# 配置Nginx
cat > /etc/nginx/sites-available/team-memory << 'EOF'
server {
    listen 80;
    server_name memory.company.local;

    root /var/www/team-memory;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

ln -s /etc/nginx/sites-available/team-memory /etc/nginx/sites-enabled/
nginx -s reload
```

#### 团队访问
```
浏览器：http://memory.company.local
编辑：克隆Git仓库后提交
自动更新：设置cron定时git pull
```

---

### 方案4: 本地文件服务器（快速测试⭐⭐⭐）

**适合**：本地测试、临时分享

#### 启动本地服务器
```bash
cd ~/team-memory-repo

# Python
python -m http.server 8000

# Node.js
npx http-server -p 8000

# PHP
php -S localhost:8000
```

#### 团队访问（同局域网）
```
浏览器：http://your-ip:8000
如：http://192.168.1.100:8000
```

**优点**：快速、无需配置
**缺点**：不持久、仅限局域网

---

### 方案5: 共享网络文件夹（最简单⭐⭐）

**适合**：非技术团队、小规模使用

#### 设置共享文件夹
```bash
# 将team-memory-repo放到共享网络驱动器
# 如：\\fileserver\shared\team-memory-repo\

# 团队成员访问
# 打开：\\fileserver\shared\team-memory-repo\index.html
```

**优点**：最简单，无需Git知识
**缺点**：无版本控制、容易冲突

---

## 📱 推荐的完整流程

### 初始设置（管理员一次性操作）

1. **创建GitHub/GitLab仓库**
   ```bash
   cd ~/team-memory-repo
   git remote add origin <your-repo-url>
   git push -u origin main
   ```

2. **启用Pages**
   - GitHub: Settings → Pages → 启用
   - GitLab: 添加.gitlab-ci.yml

3. **分享链接给团队**
   ```
   Web界面：https://your-org.github.io/team-memory/
   Git仓库：https://github.com/your-org/team-memory.git
   ```

### 团队成员日常使用

#### 新成员加入
```bash
# 1. 克隆仓库
git clone https://github.com/your-org/team-memory.git ~/team-memory-repo

# 2. 浏览Web界面
# 打开浏览器访问：https://your-org.github.io/team-memory/

# 3. 阅读QUICKSTART.md了解使用方法
```

#### 日常工作流
```bash
# 早上：获取最新知识
cd ~/team-memory-repo
git pull

# 查看最新更新
git log -5 --oneline

# 浏览Web界面
# 访问：https://your-org.github.io/team-memory/

# 工作中：与Claude Code对话
cd ~/my-project
# 在.claude.local.md中引用团队记忆
claude code

# 对话后：记录重要内容
cd ~/team-memory-repo
./scripts/capture.bat my-topic
# 编辑文件...

# 提交：分享给团队
git add .
git commit -m "feat: 添加XX讨论 by @yourname"
git push

# Web界面会自动更新（如果用了Pages）
```

---

## 🎯 最佳实践建议

### 什么对话值得记录？

**✅ 应该记录**：
- 重要的技术决策
- 复杂问题的解决方案
- 架构设计讨论
- 技术调研成果
- 常见问题的解答
- 创新的实现思路

**❌ 不需要记录**：
- 简单的语法查询
- 一次性的临时任务
- 个人学习笔记（用.local.md）
- 重复性的对话

### 记录频率建议

- **每天**：1-2个重要对话
- **每周**：整理一次主题文档
- **每月**：归档和重构知识

### 命名规范

```bash
# 好的命名
./capture.bat auth-jwt-implementation
./capture.bat redis-performance-optimization
./capture.bat react-component-architecture

# 避免的命名
./capture.bat discussion1
./capture.bat temp
./capture.bat test
```

---

## 🔧 自动化改进

为了让流程更顺畅，可以考虑：

### 1. Git自动同步
```bash
# 定时任务：每小时自动pull
crontab -e
0 * * * * cd ~/team-memory-repo && git pull
```

### 2. 提交提醒
在`.git/hooks/pre-commit`添加检查：
```bash
#!/bin/bash
# 检查是否有未填写的模板字段
if grep -r "\[描述对话的背景和目的\]" conversations/; then
    echo "❌ 请完成对话记录的内容填写"
    exit 1
fi
```

### 3. Web自动刷新
使用GitHub Actions自动部署：
```yaml
# .github/workflows/deploy.yml
name: Deploy to Pages
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./
```

---

## 💡 总结

### 推荐配置组合

**小团队（2-5人）**：
- Git仓库 + 本地文件服务器
- 或 GitHub + GitHub Pages

**中型团队（5-20人）**：
- GitHub/GitLab私有仓库 + Pages
- 配合自动化脚本

**大型企业**：
- GitLab私有部署 + 企业Pages
- 集成CI/CD
- 配合权限管理

### 最简单的开始方式

1. 创建GitHub仓库（5分钟）
2. 启用GitHub Pages（2分钟）
3. 分享链接给团队
4. 团队成员克隆仓库开始使用

**一个链接解决所有问题**：`https://your-org.github.io/team-memory/`

需要我帮你配置GitHub仓库和Pages吗？
