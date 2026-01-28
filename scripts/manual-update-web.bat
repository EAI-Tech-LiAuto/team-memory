@echo off
chcp 65001 >nul
color 0B
title 手动更新网页

echo.
echo ================================================
echo    🔄 手动更新团队知识库网页
echo ================================================
echo.

REM 检查是否在正确的目录
if not exist ".git" (
    echo ❌ 错误：当前不在知识库目录中！
    echo.
    echo 请按以下步骤操作：
    echo 1. 打开"team-memory"文件夹
    echo 2. 右键点击空白处
    echo 3. 选择"在终端中打开"
    echo 4. 重新运行此脚本
    echo.
    pause
    exit /b 1
)

echo 🔍 扫描所有对话文件...
echo.

powershell -ExecutionPolicy Bypass -File scripts\update-index.ps1

if errorlevel 1 (
    echo.
    echo ❌ 更新失败！
    echo.
    echo 可能的原因：
    echo 1. PowerShell执行策略限制 - 请以管理员身份运行
    echo 2. 文件权限问题
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================
echo    📤 提交更新
echo ================================================
echo.

set /p commit="是否要提交这次更新到GitHub？(y/n): "
if /i not "%commit%"=="y" (
    echo.
    echo ✅ 网页已更新，但未提交到GitHub
    echo    你可以稍后手动提交
    echo.
    pause
    exit /b 0
)

git add index.html
git commit -m "chore: 手动更新网页索引"
git push

if errorlevel 1 (
    echo.
    echo ⚠️  提交失败，请手动操作
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================
echo    ✨ 完成！
echo ================================================
echo.
echo ✅ 网页已更新并同步到GitHub
echo 🌐 访问：https://eai-tech-liauto.github.io/team-memory/
echo.
pause
