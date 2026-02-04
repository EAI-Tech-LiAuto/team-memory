#!/bin/bash
# 自动同步下载的调研记录到仓库并提交

REPO_DIR="$HOME/Desktop/team-memory"
DOWNLOADS_DIR="$HOME/Downloads"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🔍 正在查找最新下载的调研文件..."

# 查找Downloads中最新的.md文件
LATEST_FILE=$(find "$DOWNLOADS_DIR" -type f -name "*.md" -print0 | xargs -0 ls -t | head -1)

if [ -z "$LATEST_FILE" ]; then
    echo "❌ 错误：在Downloads文件夹中没有找到.md文件"
    exit 1
fi

FILENAME=$(basename "$LATEST_FILE")
echo "📄 找到文件: $FILENAME"

# 判断文件应该放在哪个目录
if [[ "$FILENAME" == *公司* ]] || [[ "$FILENAME" == *企业* ]] || [[ "$FILENAME" == *科技* ]]; then
    TARGET_DIR="$REPO_DIR/research/companies"
    CATEGORY="企业"
elif [[ "$FILENAME" == *大学* ]] || [[ "$FILENAME" == *学院* ]]; then
    TARGET_DIR="$REPO_DIR/research/universities"
    CATEGORY="高校"
elif [[ "$FILENAME" == *教授* ]] || [[ "$FILENAME" == *专家* ]]; then
    TARGET_DIR="$REPO_DIR/research/experts"
    CATEGORY="专家"
else
    TARGET_DIR="$REPO_DIR/research/companies"
    CATEGORY="调研"
fi

echo "📁 目标目录: $TARGET_DIR"

# 复制文件
cp "$LATEST_FILE" "$TARGET_DIR/"
echo "✅ 文件已复制到仓库"

# 切换到仓库目录
cd "$REPO_DIR" || exit 1

# 运行 update-index.py 自动更新主页
echo "🔄 正在更新主页索引..."
if [ -f "$SCRIPT_DIR/update-index.py" ]; then
    python3 "$SCRIPT_DIR/update-index.py"
    if [ $? -eq 0 ]; then
        echo "✅ 主页索引已更新"
    else
        echo "⚠️  主页索引更新失败，但文件已同步"
    fi
else
    echo "⚠️  未找到 update-index.py，跳过主页更新"
fi

# Git 操作
echo "📤 正在提交到Git..."
git add research/ index.html
git commit -m "update: 更新${CATEGORY}调研信息 - $FILENAME

通过自动化脚本更新
- 同步调研记录文件
- 自动更新主页卡片

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# 推送到远程
echo "🚀 正在推送到GitHub..."
git push

echo ""
echo "✨ 完成！调研记录已同步并推送到GitHub"
echo "📄 文件: $FILENAME"
echo "🌐 刷新网页即可查看更新"
echo ""
