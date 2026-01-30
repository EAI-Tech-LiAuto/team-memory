#!/bin/bash

# 使用方法：
# ./scripts/add-conversation-auto.sh "作者名" "对话主题" "简短描述" "标签1,标签2"

# 设置颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查参数
if [ $# -lt 2 ]; then
    echo -e "${RED}❌ 使用方法错误！${NC}"
    echo ""
    echo "用法："
    echo "  $0 \"作者名\" \"对话主题\" [\"简短描述\"] [\"标签1,标签2\"]"
    echo ""
    echo "示例："
    echo "  $0 \"张三\" \"机械臂设计方案\" \"讨论机械臂的设计细节\" \"robotics,design\""
    echo ""
    exit 1
fi

author="$1"
topic="$2"
description="${3:-}"
tags="${4:-未分类}"

echo -e "${BLUE}"
echo "================================================"
echo "   🤖 团队知识库 - 添加对话记录（自动模式）"
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
    echo -e "${YELLOW}⚠️  同步失败，但继续执行...${NC}"
    echo ""
fi

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   信息确认${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo "👤 作者: $author"
echo "📝 主题: $topic"
echo "📋 描述: $description"
echo "🏷️  标签: $tags"
echo ""

# 生成文件名
filename=$(echo "$topic" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/\.md$//')

# 获取当前日期
today=$(date +%Y-%m-%d)

# 创建文件路径
filepath="conversations/2026-01/${filename}.md"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   创建文件${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo -e "📄 创建文件：${GREEN}${filepath}${NC}"
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
echo -e "${BLUE}   打开编辑器${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# 自动打开编辑器
if command -v code &> /dev/null; then
    echo "📝 使用 VS Code 打开文件..."
    code "$filepath"
elif command -v nano &> /dev/null; then
    echo "📝 使用 nano 编辑器..."
    nano "$filepath"
elif command -v vim &> /dev/null; then
    echo "📝 使用 vim 编辑器..."
    vim "$filepath"
else
    echo "📝 使用系统默认编辑器..."
    open "$filepath"
fi

echo ""
echo -e "${GREEN}✅ 文件已创建并打开编辑器${NC}"
echo ""
echo "接下来请："
echo "1. 在编辑器中粘贴对话内容"
echo "2. 保存文件"
echo "3. 运行提交命令："
echo ""
echo -e "${YELLOW}   cd ~/desktop/team-memory${NC}"
echo -e "${YELLOW}   python3 scripts/update-index.py${NC}"
echo -e "${YELLOW}   git add .${NC}"
echo -e "${YELLOW}   git commit -m \"feat: 添加「${topic}」对话记录 by @${author}\"${NC}"
echo -e "${YELLOW}   git push${NC}"
echo ""
echo "或者运行快速提交脚本："
echo -e "${YELLOW}   ./scripts/quick-commit.sh \"${topic}\" \"${author}\"${NC}"
echo ""
