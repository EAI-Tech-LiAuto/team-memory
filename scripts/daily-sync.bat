@echo off
chcp 65001 >nul
color 0B
title 同步团队知识库

echo.
echo ================================================
echo    🤖 团队知识库 - 每日同步
echo ================================================
echo.

REM 检查是否在正确的目录
if not exist ".git" (
    echo ❌ 错误：请在team-memory目录中运行此脚本！
    pause
    exit /b 1
)

echo 📥 正在获取团队最新内容...
echo.

git fetch origin

echo.
echo 📊 检查更新情况...
echo.

REM 检查是否有更新
git status -uno | find "Your branch is behind" >nul
if %errorlevel%==0 (
    echo ✅ 发现新内容！正在下载...
    echo.
    git pull
    if errorlevel 1 (
        echo.
        echo ❌ 同步失败！
        echo.
        echo 可能的原因：
        echo 1. 你有未提交的本地改动
        echo 2. 存在冲突
        echo.
        echo 💡 建议：
        echo 1. 先保存你的改动：git stash
        echo 2. 再次同步：git pull
        echo 3. 恢复改动：git stash pop
        echo.
        echo 或者联系技术同事协助。
        pause
        exit /b 1
    )
    echo.
    echo ✅ 同步成功！
    echo.
    echo 📋 更新内容：
    git log --oneline --decorate -5
) else (
    echo ✅ 已经是最新版本！
)

echo.
echo ================================================
echo    完成！
echo ================================================
echo.
echo 💡 提示：建议每天工作前运行此脚本
echo.
pause
