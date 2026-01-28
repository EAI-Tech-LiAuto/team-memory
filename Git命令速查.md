# 🎯 Git命令快速参考卡

**打印出来贴在电脑旁边！**

---

## 🔥 最常用的3个命令（90%情况够用）

```bash
# 1️⃣ 每天开始前（必做）
git pull

# 2️⃣ 添加你的改动
git add .

# 3️⃣ 提交并上传
git commit -m "你的说明"
git push
```

---

## 📋 完整工作流程

### 早上第一件事
```bash
cd Desktop/team-memory    # 进入目录
git pull                  # 同步最新内容
```

### 添加新内容
```bash
# 方法1: 使用脚本（推荐）⭐⭐⭐⭐⭐
双击：scripts/add-conversation.bat

# 方法2: 手动操作
# 1. 创建或编辑文件
# 2. 保存文件
git add .
git commit -m "添加XX内容 by @你的名字"
git push
```

### 检查状态
```bash
git status    # 看看有什么改动
git diff      # 看看改了什么内容
```

---

## 🆘 遇到问题时

### 问题1: push时提示要先pull
```bash
git pull
git add .
git commit -m "合并更新"
git push
```

### 问题2: 改错了想撤销（没push前）
```bash
git checkout .    # 撤销所有改动
```

### 问题3: 完全搞不懂了
```bash
# ⚠️ 会丢失本地改动！先备份重要文件！
git reset --hard origin/main
git pull
```

---

## 💡 黄金规则

1. ✅ **每天开始前先 pull** - 避免99%的冲突
2. ✅ **频繁提交** - 小步快跑好过一次大改
3. ✅ **写清楚commit信息** - 方便自己和队友查找
4. ✅ **不确定就先问** - 不要害怕弄坏（都能恢复）

---

## 📞 求助清单

1. **查看新手指南**: 打开 `新手指南.md`
2. **技术同事**: 李君、郎博、朱俊蓉
3. **GitHub网页**: https://github.com/EAI-Tech-LiAuto/team-memory

---

## 🎁 快捷脚本

**Windows用户**（双击运行）:
- `scripts/add-conversation.bat` - 添加对话记录
- `scripts/daily-sync.bat` - 每日同步

**Mac/Linux用户**:
```bash
./scripts/add-conversation.sh
```

---

**记住**: Git不可怕，就是个同步工具！多用几次就熟了 🎉
