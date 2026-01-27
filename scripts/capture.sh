#!/bin/bash
# 快速捕获对话到团队记忆库
# 使用方法: ./capture.sh <topic-name> [author]

set -e

TOPIC="${1}"
AUTHOR="${2:-$(git config user.name 2>/dev/null || echo 'unknown')}"

if [ -z "$TOPIC" ]; then
  echo "❌ 错误: 请提供话题名称"
  echo ""
  echo "使用方法:"
  echo "  ./capture.sh <topic-name> [author]"
  echo ""
  echo "示例:"
  echo "  ./capture.sh embodied-ai-research"
  echo "  ./capture.sh jwt-auth-implementation alice"
  exit 1
fi

# 获取当前日期和年月
DATE=$(date +%Y-%m-%d 2>/dev/null || echo "2026-01-27")
YEAR_MONTH=$(echo $DATE | cut -d'-' -f1,2)

# 构建文件路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
CONV_DIR="$REPO_ROOT/conversations/$YEAR_MONTH"
FILENAME="$CONV_DIR/${TOPIC}.md"

# 创建目录
mkdir -p "$CONV_DIR"

# 检查文件是否已存在
if [ -f "$FILENAME" ]; then
  echo "⚠️  警告: 文件已存在: $FILENAME"
  read -p "是否覆盖? (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "已取消"
    exit 0
  fi
fi

# 创建文件
cat > "$FILENAME" <<EOF
---
date: $DATE
author: $AUTHOR
topic: $TOPIC
tags: []
related_files: []
status: draft
---

# $TOPIC

## 会话背景
[描述对话的背景和目的]

## 关键发现
[记录重要的发现和结论]

### 要点1
[详细描述]

### 要点2
[详细描述]

## 代码示例
\`\`\`
// 如果有代码，在这里添加
\`\`\`

## 后续行动
- [ ] 待办事项1
- [ ] 待办事项2

## 相关链接
- [相关文档]()

## Claude Code使用
[记录使用了哪些Claude Code功能]

---

**总结**: [一句话总结本次对话的价值]
EOF

echo "✅ 创建对话记录: $FILENAME"
echo ""
echo "下一步:"
echo "1. 编辑文件填写内容"
echo "2. cd $REPO_ROOT"
echo "3. git add ."
echo "4. git commit -m \"feat(conversation): 添加 $TOPIC by @$AUTHOR\""
echo "5. git push"
echo ""

# 尝试用编辑器打开（可选）
if command -v code &> /dev/null; then
  echo "使用VSCode打开..."
  code "$FILENAME"
elif [ -n "$EDITOR" ]; then
  echo "使用 $EDITOR 打开..."
  $EDITOR "$FILENAME"
fi
