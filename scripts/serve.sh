#!/bin/bash
# 本地启动Web服务器脚本
# 使用方法: ./serve.sh [port]

PORT="${1:-8000}"

echo "🚀 启动团队记忆库Web服务器..."
echo "📍 端口: $PORT"
echo "🌐 访问地址: http://localhost:$PORT"
echo ""
echo "按 Ctrl+C 停止服务器"
echo ""

# 检测可用的服务器
if command -v python3 &> /dev/null; then
    echo "使用 Python 3..."
    python3 -m http.server $PORT
elif command -v python &> /dev/null; then
    echo "使用 Python..."
    python -m http.server $PORT
elif command -v php &> /dev/null; then
    echo "使用 PHP..."
    php -S localhost:$PORT
elif command -v npx &> /dev/null; then
    echo "使用 Node.js http-server..."
    npx http-server -p $PORT
else
    echo "❌ 错误: 未找到可用的服务器"
    echo "请安装以下任一工具："
    echo "  - Python 3"
    echo "  - PHP"
    echo "  - Node.js"
    exit 1
fi
