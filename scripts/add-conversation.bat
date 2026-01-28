@echo off
chcp 65001 >nul
color 0A
title 添加对话到团队知识库

echo.
echo ================================================
echo    🤖 团队知识库 - 添加对话记录
echo ================================================
echo.

REM 检查是否在正确的目录
if not exist ".git" (
    echo ❌ 错误：当前不在知识库目录中！
    echo.
    echo 请按以下步骤操作：
    echo 1. 打开"team-memory"文件夹
    echo 2. 右键点击空白处
    echo 3. 选择"在终端中打开"或"Git Bash Here"
    echo 4. 重新运行此脚本
    echo.
    pause
    exit /b 1
)

echo 📥 正在同步最新内容...
git pull
if errorlevel 1 (
    echo.
    echo ⚠️  同步失败，但可以继续。如果担心冲突，请先联系技术同事。
    echo.
    set /p continue="是否继续？(y/n): "
    if /i not "%continue%"=="y" exit /b 1
)

echo.
echo ================================================
echo    第1步：填写基本信息
echo ================================================
echo.

REM 获取用户信息
set /p author="👤 你的名字（如：张三）: "
if "%author%"=="" (
    echo ❌ 名字不能为空！
    pause
    exit /b 1
)

set /p topic="📝 对话主题（如：机械臂设计方案）: "
if "%topic%"=="" (
    echo ❌ 主题不能为空！
    pause
    exit /b 1
)

set /p description="📋 简短描述（一句话说明内容）: "

set /p tags="🏷️  标签（用逗号分隔，如：robotics,design）: "
if "%tags%"=="" set tags=未分类

REM 生成文件名（去除空格，转小写）
set filename=%topic%
set filename=%filename: =-%
set filename=%filename:.md=%

REM 获取当前日期
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do (
    set year=%%a
    set month=%%b
    set day=%%c
)
set today=%year%-%month%-%day%

REM 创建文件路径
set filepath=conversations\2026-01\%filename%.md

echo.
echo ================================================
echo    第2步：创建文件
echo ================================================
echo.
echo 📄 将创建文件：%filepath%
echo.

REM 创建文件内容
(
echo ---
echo date: %today%
echo author: %author%
echo topic: %topic%
echo tags: [%tags%]
echo related_files: []
echo status: completed
echo ---
echo.
echo # %topic%
echo.
echo ## 概述
echo.
echo %description%
echo.
echo ## 详细内容
echo.
echo 请在下方粘贴你的对话内容...
echo.
echo ---
echo.
echo **贡献者**: %author%
echo **日期**: %today%
) > "%filepath%"

if errorlevel 1 (
    echo ❌ 文件创建失败！
    pause
    exit /b 1
)

echo ✅ 文件创建成功！
echo.
echo ================================================
echo    第3步：编辑内容
echo ================================================
echo.
echo 📝 即将打开编辑器，请：
echo    1. 找到"## 详细内容"部分
echo    2. 删除提示文字
echo    3. 粘贴你的对话内容
echo    4. 保存并关闭编辑器
echo.
echo 按任意键打开编辑器...
pause >nul

REM 尝试用不同编辑器打开
if exist "C:\Program Files\Microsoft VS Code\Code.exe" (
    "C:\Program Files\Microsoft VS Code\Code.exe" "%filepath%"
) else if exist "%LocalAppData%\Programs\Microsoft VS Code\Code.exe" (
    "%LocalAppData%\Programs\Microsoft VS Code\Code.exe" "%filepath%"
) else (
    notepad "%filepath%"
)

echo.
echo 编辑完成后，请保存并关闭编辑器。
echo.
set /p edited="✅ 确认已完成编辑？(y/n): "
if /i not "%edited%"=="y" (
    echo.
    echo ⚠️  取消操作。文件已保存在：%filepath%
    echo    你可以稍后手动编辑并提交。
    pause
    exit /b 0
)

echo.
echo ================================================
echo    第4步：提交到团队库
echo ================================================
echo.

echo 📤 正在准备提交...
git add .

echo 📝 正在创建提交记录...
git commit -m "feat: 添加「%topic%」对话记录 by @%author%"

if errorlevel 1 (
    echo.
    echo ⚠️  提交失败！可能是没有改动需要提交。
    echo.
    pause
    exit /b 1
)

echo 🚀 正在上传到GitHub...
git push

if errorlevel 1 (
    echo.
    echo ❌ 上传失败！
    echo.
    echo 可能的原因：
    echo 1. 网络问题 - 请检查网络连接
    echo 2. 需要先pull - 有同事在你之前提交了内容
    echo 3. 权限问题 - 请确认你有仓库访问权限
    echo.
    echo 尝试自动修复...
    git pull --rebase
    if errorlevel 1 (
        echo.
        echo ⚠️  自动修复失败，请联系技术同事协助。
        echo.
        pause
        exit /b 1
    )
    echo 正在重新上传...
    git push
    if errorlevel 1 (
        echo ❌ 仍然失败，请联系技术同事。
        pause
        exit /b 1
    )
)

echo.
echo ================================================
echo    🎉 成功！
echo ================================================
echo.
echo ✅ 你的对话记录已成功分享到团队知识库！
echo.
echo 📊 文件位置：%filepath%
echo 🌐 网站将在1-2分钟后自动更新
echo 🔗 访问：https://eai-tech-liauto.github.io/team-memory/
echo.
echo 感谢你的贡献！💪
echo.
pause
