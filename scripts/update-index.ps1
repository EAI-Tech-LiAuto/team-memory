# 自动更新index.html的PowerShell脚本
# 扫描conversations目录下的所有markdown文件，读取元数据，自动生成网页内容

param(
    [string]$RepoPath = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Continue"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " 自动更新 index.html" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "仓库路径: $RepoPath" -ForegroundColor Yellow
Write-Host ""

# 扫描对话文件
Write-Host "扫描对话文件..." -ForegroundColor Cyan
Write-Host ""

$conversations = @()
$convPath = Join-Path $RepoPath "conversations"

if (!(Test-Path $convPath)) {
    Write-Host "找不到conversations目录: $convPath" -ForegroundColor Red
    exit 1
}

# 递归查找所有.md文件
Get-ChildItem -Path $convPath -Filter "*.md" -Recurse | ForEach-Object {
    try {
        $content = Get-Content $_.FullName -Raw -Encoding UTF8

        # 提取YAML frontmatter
        if ($content -match '(?s)^---\s*\r?\n(.*?)\r?\n---\s*\r?\n(.*)$') {
            $frontmatter = $matches[1]
            $markdown = $matches[2]

            # 解析YAML
            $metadata = @{}
            $frontmatter -split "\r?\n" | ForEach-Object {
                if ($_ -match '^\s*(\w+):\s*(.+)$') {
                    $key = $matches[1].Trim()
                    $value = $matches[2].Trim()

                    # 处理数组格式
                    if ($value -match '^\[(.*)\]$') {
                        $value = $matches[1] -split ',' | ForEach-Object { $_.Trim() }
                    }

                    $metadata[$key] = $value
                }
            }

            # 提取摘要
            $summary = ""
            if ($markdown -match '##\s*会话背景\s*\r?\n+(.*?)(?=\r?\n##|\Z)') {
                $summary = $matches[1].Trim()
                if ($summary.Length -gt 150) { $summary = $summary.Substring(0, 150) }
            } elseif ($markdown -match '##\s*关键发现\s*\r?\n+(.*?)(?=\r?\n##|\Z)') {
                $summary = $matches[1].Trim()
                if ($summary.Length -gt 150) { $summary = $summary.Substring(0, 150) }
            } else {
                $cleanText = $markdown -replace '#+\s+.*', '' -replace '(?s)```.*?```', '' -replace '`[^`]+`', ''
                $cleanText = $cleanText -replace '\!\[.*?\]\(.*?\)', '' -replace '\[([^\]]+)\]\([^\)]+\)', '$1'
                $cleanText = ($cleanText -replace '\s+', ' ').Trim()
                if ($cleanText.Length -gt 150) { $cleanText = $cleanText.Substring(0, 150) }
                $summary = $cleanText
            }

            # 获取相对路径
            $relPath = $_.FullName.Substring($RepoPath.Length + 1).Replace('\', '/')

            $conversations += @{
                Path = $relPath
                FileName = $_.Name
                Date = if ($metadata.ContainsKey('date')) { $metadata['date'] } else { "" }
                Author = if ($metadata.ContainsKey('author')) { $metadata['author'] } else { "未知" }
                Topic = if ($metadata.ContainsKey('topic')) { $metadata['topic'] } else { $_.BaseName }
                Tags = if ($metadata.ContainsKey('tags')) { $metadata['tags'] } else { @() }
                Summary = $summary
            }

            Write-Host "✓ 已读取: $relPath" -ForegroundColor Green
        }
    } catch {
        Write-Host "⚠ 读取文件失败: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# 按日期排序
$conversations = $conversations | Sort-Object -Property Date -Descending

Write-Host ""
Write-Host "找到 $($conversations.Count) 个对话文件"
Write-Host ""

if ($conversations.Count -eq 0) {
    Write-Host "没有找到任何对话文件" -ForegroundColor Yellow
    exit 0
}

# 读取现有的index.html
Write-Host "更新 index.html..." -ForegroundColor Cyan
$indexPath = Join-Path $RepoPath "index.html"

if (!(Test-Path $indexPath)) {
    Write-Host "找不到index.html: $indexPath" -ForegroundColor Red
    exit 1
}

$htmlContent = Get-Content $indexPath -Raw -Encoding UTF8

# 统计信息
$totalConversations = $conversations.Count
$authors = $conversations | Select-Object -ExpandProperty Author -Unique
$totalAuthors = $authors.Count

# 更新统计数字
$htmlContent = $htmlContent -replace '(<div class="stat-card">\s*<div class="stat-number">)\d+(</div>\s*<div class="stat-label">对话记录</div>)', "`$1$totalConversations`$2"
$htmlContent = $htmlContent -replace '(<div class="stat-card">\s*<div class="stat-number">)\d+(</div>\s*<div class="stat-label">贡献者</div>)', "`$1$totalAuthors`$2"

# 生成对话卡片HTML
$cardsHtml = ""
foreach ($conv in $conversations) {
    $tagsHtml = ""
    if ($conv.Tags -is [array]) {
        foreach ($tag in $conv.Tags) {
            $tagsHtml += "                            <span class=`"tag`">$tag</span>`n"
        }
    }

    $cardHtml = @"
                    <div class="card" onclick="window.open('viewer.html?file=./$($conv.Path)')">
                        <div class="card-header">
                            <div class="card-title">$($conv.Topic)</div>
                            <div class="card-date">$($conv.Date)</div>
                        </div>
                        <div class="card-meta">
                            <div class="card-author">$($conv.Author)</div>
                        </div>
                        <div class="card-tags">
$tagsHtml                        </div>
                        <div class="card-summary">
                            $($conv.Summary)
                        </div>
                    </div>

"@
    $cardsHtml += $cardHtml
}

# 替换最新对话部分
$pattern1 = '(?s)(<h2 class="section-title">[^<]+最新对话</h2>\s*<div class="cards">)(.*?)(</div>\s*</div>\s*<div class="section">)'
$replacement1 = "`$1`n$cardsHtml                `$3"
$htmlContent = $htmlContent -replace $pattern1, $replacement1

# 生成时间线HTML
$timelineHtml = ""
foreach ($conv in $conversations) {
    $timelineItemHtml = @"
                    <div class="timeline-item">
                        <div class="card-header">
                            <div class="card-title">$($conv.Topic)</div>
                            <div class="card-date">$($conv.Date)</div>
                        </div>
                        <div class="card-meta">
                            <div class="card-author">$($conv.Author)</div>
                        </div>
                        <div class="card-summary">
                            $($conv.Summary)
                        </div>
                    </div>

"@
    $timelineHtml += $timelineItemHtml
}

# 替换时间线部分
$pattern2 = '(?s)(<h2 class="section-title">[^<]+时间线</h2>\s*<div class="timeline">)(.*?)(</div>\s*</div>\s*</div>\s*<div class="footer">)'
$replacement2 = "`$1`n$timelineHtml                `$3"
$htmlContent = $htmlContent -replace $pattern2, $replacement2

# 写回文件
$htmlContent | Out-File -FilePath $indexPath -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "成功更新 index.html" -ForegroundColor Green
Write-Host "   - 对话记录: $totalConversations 篇"
Write-Host "   - 贡献者: $totalAuthors 人"
Write-Host ""

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " 完成！网页内容已自动更新" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
