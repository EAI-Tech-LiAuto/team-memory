#!/bin/bash

# 设置颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE}"
echo "================================================"
echo "   🤖 团队知识库 - 添加对话记录"
echo "================================================"
echo -e "${NC}"

# 检查是否在正确的目录
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ 错误：当前不在知识库目录中！${NC}"
    echo ""
    echo "请按以下步骤操作："
    echo "1. cd到team-memory目录"
    echo "2. 重新运行此脚本"
    echo ""
    exit 1
fi

# 同步最新内容
echo -e "${BLUE}📥 正在同步最新内容...${NC}"
if ! git pull; then
    echo ""
    echo -e "${YELLOW}⚠️  同步失败，但可以继续。如果担心冲突，请先联系技术同事。${NC}"
    echo ""
    read -p "是否继续？(y/n): " continue
    if [ "$continue" != "y" ]; then
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   第1步：填写基本信息${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# 获取用户信息
read -p "👤 你的名字（如：张三）: " author
if [ -z "$author" ]; then
    echo -e "${RED}❌ 名字不能为空！${NC}"
    exit 1
fi

read -p "📝 对话主题（如：机械臂设计方案）: " topic
if [ -z "$topic" ]; then
    echo -e "${RED}❌ 主题不能为空！${NC}"
    exit 1
fi

read -p "📋 简短描述（一句话说明内容）: " description

read -p "🏷️  标签（用逗号分隔，如：robotics,design）: " tags
if [ -z "$tags" ]; then
    tags="未分类"
fi

# 生成文件名
filename=$(echo "$topic" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/\.md$//')

# 获取当前日期
today=$(date +%Y-%m-%d)

# 创建文件路径
filepath="conversations/2026-01/${filename}.md"

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   第2步：创建文件${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo -e "📄 将创建文件：${GREEN}${filepath}${NC}"
echo ""

# 创建文件内容
cat > "$filepath" << EOF
---
date: ${today}
author: ${author}
topic: ${topic}
tags: [${tags}]
related_files: []
status: completed
---

# ${topic}

## 概述

${description}

## 详细内容

请在下方粘贴你的对话内容...

---

**贡献者**: ${author}
**日期**: ${today}
EOF

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 文件创建失败！${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 文件创建成功！${NC}"
echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   第3步：编辑内容${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo "📝 即将打开编辑器，请："
echo "   1. 找到'## 详细内容'部分"
echo "   2. 删除提示文字"
echo "   3. 粘贴你的对话内容"
echo "   4. 保存并关闭编辑器"
echo ""
read -p "按回车打开编辑器..."

# 尝试不同编辑器
if command -v code &> /dev/null; then
    code "$filepath"
elif command -v nano &> /dev/null; then
    nano "$filepath"
elif command -v vim &> /dev/null; then
    vim "$filepath"
else
    open "$filepath"
fi

echo ""
read -p "✅ 确认已完成编辑？(y/n): " edited
if [ "$edited" != "y" ]; then
    echo ""
    echo -e "${YELLOW}⚠️  取消操作。文件已保存在：${filepath}${NC}"
    echo "   你可以稍后手动编辑并提交。"
    exit 0
fi

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   第4步：提交到团队库${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

echo "📤 正在准备提交..."
git add .

echo "📝 正在创建提交记录..."
if ! git commit -m "feat: 添加「${topic}」对话记录 by @${author}"; then
    echo ""
    echo -e "${YELLOW}⚠️  提交失败！可能是没有改动需要提交。${NC}"
    exit 1
fi

echo "🚀 正在上传到GitHub..."
if ! git push; then
    echo ""
    echo -e "${RED}❌ 上传失败！${NC}"
    echo ""
    echo "可能的原因："
    echo "1. 网络问题 - 请检查网络连接"
    echo "2. 需要先pull - 有同事在你之前提交了内容"
    echo "3. 权限问题 - 请确认你有仓库访问权限"
    echo ""
    echo "尝试自动修复..."
    if ! git pull --rebase; then
        echo ""
        echo -e "${RED}⚠️  自动修复失败，请联系技术同事协助。${NC}"
        exit 1
    fi
    echo "正在重新上传..."
    if ! git push; then
        echo -e "${RED}❌ 仍然失败，请联系技术同事。${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}   🎉 成功！${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo "✅ 你的对话记录已成功分享到团队知识库！"
echo ""
echo "📊 文件位置：${filepath}"
echo "🌐 网站将在1-2分钟后自动更新"
echo "🔗 访问：https://eai-tech-liauto.github.io/team-memory/"
echo ""
echo "感谢你的贡献！💪"
echo ""
