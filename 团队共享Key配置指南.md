# 团队共享API Key配置指南

## 🔧 如何配置团队共享Key

### 方法：直接编辑代码文件

1. **打开文件**
   - 文件路径：`scripts/groq-api.js`

2. **找到第97行**
   ```javascript
   this.teamSharedKey = ''; // 管理员：在这里填写团队共享的Groq API Key
   ```

3. **填写你的Groq API Key**
   ```javascript
   this.teamSharedKey = 'gsk_YOUR_API_KEY_HERE'; // 替换为实际的Key
   ```

4. **保存并提交**
   ```bash
   git add scripts/groq-api.js
   git commit -m "config: 配置团队共享Groq API Key"
   git push
   ```

5. **等待部署**（3-5分钟）

---

## 📝 获取Groq API Key

如果你还没有Key，可以：

### 选项1：让团队其他人注册（推荐）

找一个有Google账号的同事：
1. 访问 https://console.groq.com
2. 用Google账号登录
3. 创建API Key
4. 复制给你

### 选项2：自己注册

1. 访问 https://console.groq.com
2. 选择 "Continue with Google"
3. 登录Google账号
4. 进入 API Keys 页面
5. 点击 "Create API Key"
6. 复制生成的Key

---

## ✅ 配置后的效果

**团队成员使用时：**
- ✅ 点击🤖按钮
- ✅ 自动使用团队共享Key
- ✅ 无需自己注册和配置
- ✅ 直接开始提问

**使用限额：**
- 共享Key：14,400次/天（全团队共享）
- 如果不够用，可以再创建一个新Key

---

## 🔄 更换Key

如果Key过期或用完了：
1. 重新注册获取新Key
2. 修改 `scripts/groq-api.js` 第97行
3. 提交并推送

---

## 💡 提示

- Key以 `gsk_` 开头
- 长度约40-60个字符
- 保管好Key，不要公开分享

---

## 🆘 遇到问题？

如果配置后还是不能用：
1. 检查Key是否完整复制
2. 检查Key两边是否有引号
3. 等待GitHub Pages部署完成
4. 清除浏览器缓存重试

---

**配置完成后，告诉团队成员直接访问网站使用即可！** 🎉
