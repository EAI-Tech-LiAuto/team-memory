#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
本地服务器 - 用于处理调研记录的保存和同步
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import subprocess
from pathlib import Path
from datetime import datetime

app = Flask(__name__)
CORS(app)  # 允许跨域请求

REPO_DIR = Path.home() / "Desktop" / "team-memory"
RESEARCH_DIR = REPO_DIR / "research" / "companies"

@app.route('/api/save-research', methods=['POST'])
def save_research():
    """保存调研记录并自动同步到Git"""
    try:
        data = request.json
        filename = data.get('filename')
        content = data.get('content')

        if not filename or not content:
            return jsonify({'success': False, 'error': '缺少文件名或内容'}), 400

        # 确定文件路径
        file_path = RESEARCH_DIR / filename

        # 保存文件
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)

        print(f"✅ 文件已保存: {file_path}")

        # Git 操作
        os.chdir(REPO_DIR)

        # 添加文件
        subprocess.run(['git', 'add', str(file_path)], check=True)

        # 提交
        commit_message = f"""update: 更新调研信息 - {filename}

通过在线编辑器更新

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"""

        subprocess.run(['git', 'commit', '-m', commit_message], check=True)

        # 推送
        subprocess.run(['git', 'push'], check=True)

        print(f"✅ 已提交并推送到GitHub")

        return jsonify({
            'success': True,
            'message': '文件已保存并同步到GitHub',
            'filename': filename
        })

    except subprocess.CalledProcessError as e:
        error_msg = f"Git操作失败: {str(e)}"
        print(f"❌ {error_msg}")
        return jsonify({'success': False, 'error': error_msg}), 500

    except Exception as e:
        error_msg = f"保存失败: {str(e)}"
        print(f"❌ {error_msg}")
        return jsonify({'success': False, 'error': error_msg}), 500

@app.route('/api/health', methods=['GET'])
def health_check():
    """健康检查"""
    return jsonify({'status': 'ok', 'message': '服务器运行中'})

if __name__ == '__main__':
    print("🚀 启动本地服务器...")
    print(f"📁 仓库目录: {REPO_DIR}")
    print(f"🌐 服务地址: http://localhost:5000")
    print("✨ 按 Ctrl+C 停止服务器")
    print()

    app.run(host='localhost', port=5000, debug=True)
