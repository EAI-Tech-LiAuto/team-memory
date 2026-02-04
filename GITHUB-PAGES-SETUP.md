# GitHub Pages 配置说明

## 启用 GitHub Pages

请按以下步骤启用 GitHub Pages：

1. 打开仓库页面：https://github.com/EAI-Tech-LiAuto/team-memory
2. 点击 Settings（设置）
3. 在左侧菜单找到 Pages
4. 在 "Source" 下选择：
   - Branch: main
   - Folder: / (root)
5. 点击 Save

等待几分钟后，网站将在以下地址可用：
**https://eai-tech-liauto.github.io/team-memory/**

## 创建 GitHub Personal Access Token

为了让网页能够保存文件到仓库，需要创建访问令牌：

1. 打开 https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 设置：
   - Note: `team-memory-editor`
   - Expiration: 90 days（或更长）
   - 勾选权限：
     - ✅ repo (完整权限)
4. 点击 "Generate token"
5. **复制生成的token**（只显示一次，请保存好）

## 配置 Token

将 token 保存到配置文件（团队管理员操作）：

```bash
cd ~/Desktop/team-memory
echo "YOUR_TOKEN_HERE" > .github-token
echo ".github-token" >> .gitignore
```

注意：
- 不要将 token 提交到 Git
- token 需要定期更新
- 只有需要在线编辑的用户需要 token

## 验证部署

部署完成后：
1. 访问 https://eai-tech-liauto.github.io/team-memory/
2. 应该能看到知识库主页
3. 所有链接和功能正常工作
