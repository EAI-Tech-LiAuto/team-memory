#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
自动更新index.html的脚本
扫描conversations目录下的所有markdown文件，读取元数据，自动生成网页内容
"""

import os
import re
from pathlib import Path
from datetime import datetime
import yaml

def parse_frontmatter(content):
    """解析markdown文件的YAML frontmatter"""
    match = re.match(r'^---\s*\n(.*?)\n---\s*\n', content, re.DOTALL)
    if match:
        try:
            metadata = yaml.safe_load(match.group(1))
            markdown_content = content[match.end():]
            return metadata, markdown_content
        except:
            return None, content
    return None, content

def extract_summary(markdown_content, max_length=100):
    """从markdown内容中提取摘要"""
    # 移除标题和代码块
    content = re.sub(r'^#+\s+.*$', '', markdown_content, flags=re.MULTILINE)
    content = re.sub(r'```.*?```', '', content, flags=re.DOTALL)
    content = re.sub(r'`[^`]+`', '', content)
    # 移除链接和图片
    content = re.sub(r'!\[.*?\]\(.*?\)', '', content)
    content = re.sub(r'\[([^\]]+)\]\([^\)]+\)', r'\1', content)
    # 移除多余空白
    content = ' '.join(content.split())
    # 截取前max_length字符
    if len(content) > max_length:
        return content[:max_length] + '...'
    return content

def scan_conversations(base_path):
    """扫描conversations目录，获取所有对话文件"""
    conversations = []
    conv_path = Path(base_path) / 'conversations'

    if not conv_path.exists():
        print(f"❌ 找不到conversations目录: {conv_path}")
        return conversations

    # 遍历所有markdown文件
    for md_file in conv_path.rglob('*.md'):
        try:
            with open(md_file, 'r', encoding='utf-8') as f:
                content = f.read()

            metadata, markdown_content = parse_frontmatter(content)

            if metadata:
                # 获取相对路径
                rel_path = md_file.relative_to(base_path).as_posix()

                # 从markdown内容中查找会话背景或关键发现作为摘要
                summary = metadata.get('summary', '')
                if not summary:
                    # 尝试提取"## 会话背景"或"## 关键发现"部分
                    bg_match = re.search(r'##\s*会话背景\s*\n+(.*?)(?=\n##|\Z)', markdown_content, re.DOTALL)
                    if bg_match:
                        summary = bg_match.group(1).strip()[:150]
                    else:
                        kf_match = re.search(r'##\s*关键发现\s*\n+(.*?)(?=\n##|\Z)', markdown_content, re.DOTALL)
                        if kf_match:
                            summary = kf_match.group(1).strip()[:150]
                        else:
                            summary = extract_summary(markdown_content, 150)

                conversations.append({
                    'path': rel_path,
                    'file_name': md_file.name,
                    'date': metadata.get('date', ''),
                    'author': metadata.get('author', '未知'),
                    'topic': metadata.get('topic', md_file.stem),
                    'tags': metadata.get('tags', []),
                    'summary': summary,
                    'metadata': metadata
                })
                print(f"✓ 已读取: {rel_path}")
        except Exception as e:
            print(f"⚠ 读取文件失败 {md_file}: {e}")

    # 按日期排序（最新的在前）
    conversations.sort(key=lambda x: x['date'], reverse=True)
    return conversations

def generate_card_html(conv):
    """生成对话卡片的HTML"""
    tags_html = '\n                            '.join([
        f'<span class="tag">{tag}</span>' for tag in conv['tags']
    ])

    return f'''                    <div class="card" onclick="window.open('viewer.html?file=./{conv['path']}')">
                        <div class="card-header">
                            <div class="card-title">{conv['topic']}</div>
                            <div class="card-date">{conv['date']}</div>
                        </div>
                        <div class="card-meta">
                            <div class="card-author">{conv['author']}</div>
                        </div>
                        <div class="card-tags">
                            {tags_html}
                        </div>
                        <div class="card-summary">
                            {conv['summary']}
                        </div>
                    </div>
'''

def generate_timeline_html(conv):
    """生成时间线条目的HTML"""
    return f'''                    <div class="timeline-item">
                        <div class="card-header">
                            <div class="card-title">{conv['topic']}</div>
                            <div class="card-date">{conv['date']}</div>
                        </div>
                        <div class="card-meta">
                            <div class="card-author">{conv['author']}</div>
                        </div>
                        <div class="card-summary">
                            {conv['summary']}
                        </div>
                    </div>
'''

def update_index_html(base_path, conversations):
    """更新index.html文件"""
    index_path = Path(base_path) / 'index.html'

    if not index_path.exists():
        print(f"❌ 找不到index.html: {index_path}")
        return False

    # 读取现有的index.html
    with open(index_path, 'r', encoding='utf-8') as f:
        html_content = f.read()

    # 统计信息
    total_conversations = len(conversations)
    authors = set(conv['author'] for conv in conversations)
    total_authors = len(authors)

    # 更新统计数字
    html_content = re.sub(
        r'(<div class="stat-card">\s*<div class="stat-number">)\d+(</div>\s*<div class="stat-label">对话记录</div>)',
        rf'\g<1>{total_conversations}\g<2>',
        html_content
    )

    html_content = re.sub(
        r'(<div class="stat-card">\s*<div class="stat-number">)\d+(</div>\s*<div class="stat-label">贡献者</div>)',
        rf'\g<1>{total_authors}\g<2>',
        html_content
    )

    # 生成最新对话卡片
    cards_html = '\n'.join([generate_card_html(conv) for conv in conversations])

    # 替换最新对话部分
    pattern = r'(<h2 class="section-title">🆕 最新对话</h2>\s*<div class="cards">)(.*?)(</div>\s*</div>\s*<div class="section">)'
    replacement = rf'\g<1>\n{cards_html}\n                \g<3>'
    html_content = re.sub(pattern, replacement, html_content, flags=re.DOTALL)

    # 生成时间线
    timeline_html = '\n'.join([generate_timeline_html(conv) for conv in conversations])

    # 替换时间线部分
    pattern = r'(<h2 class="section-title">⏱️ 时间线</h2>\s*<div class="timeline">)(.*?)(</div>\s*</div>\s*</div>\s*<div class="footer">)'
    replacement = rf'\g<1>\n{timeline_html}\n                \g<3>'
    html_content = re.sub(pattern, replacement, html_content, flags=re.DOTALL)

    # 写回文件
    with open(index_path, 'w', encoding='utf-8') as f:
        f.write(html_content)

    print(f"\n✅ 成功更新 index.html")
    print(f"   - 对话记录: {total_conversations} 篇")
    print(f"   - 贡献者: {total_authors} 人")
    return True

def main():
    """主函数"""
    print("=" * 60)
    print("🔄 自动更新 index.html")
    print("=" * 60)

    # 获取仓库根目录
    script_dir = Path(__file__).parent
    repo_root = script_dir.parent

    print(f"\n📁 仓库路径: {repo_root}")

    # 扫描对话文件
    print("\n📖 扫描对话文件...")
    conversations = scan_conversations(repo_root)

    if not conversations:
        print("\n⚠ 没有找到任何对话文件")
        return

    print(f"\n找到 {len(conversations)} 个对话文件")

    # 更新index.html
    print("\n📝 更新 index.html...")
    update_index_html(repo_root, conversations)

    print("\n" + "=" * 60)
    print("✨ 完成！网页内容已自动更新")
    print("=" * 60)

if __name__ == '__main__':
    main()
