@echo off
REM Windows批处理版本的capture脚本
REM 使用方法: capture.bat <topic-name> [author]

setlocal enabledelayedexpansion

set TOPIC=%1
set AUTHOR=%2

if "%TOPIC%"=="" (
    echo ❌ 错误: 请提供话题名称
    echo.
    echo 使用方法:
    echo   capture.bat ^<topic-name^> [author]
    echo.
    echo 示例:
    echo   capture.bat embodied-ai-research
    echo   capture.bat jwt-auth-implementation alice
    exit /b 1
)

if "%AUTHOR%"=="" (
    for /f "tokens=*" %%a in ('git config user.name 2^>nul') do set AUTHOR=%%a
    if "!AUTHOR!"=="" set AUTHOR=unknown
)

REM 获取当前日期
for /f "tokens=1-3 delims=/" %%a in ('date /t') do (
    set DATE=%%c-%%a-%%b
)

REM 提取年-月
for /f "tokens=1,2 delims=-" %%a in ("%DATE%") do (
    set YEAR_MONTH=%%a-%%b
)

REM 构建路径
set SCRIPT_DIR=%~dp0
set REPO_ROOT=%SCRIPT_DIR%..
set CONV_DIR=%REPO_ROOT%\conversations\%YEAR_MONTH%
set FILENAME=%CONV_DIR%\%TOPIC%.md

REM 创建目录
if not exist "%CONV_DIR%" mkdir "%CONV_DIR%"

REM 检查文件是否存在
if exist "%FILENAME%" (
    echo ⚠️  警告: 文件已存在: %FILENAME%
    set /p OVERWRITE="是否覆盖? (y/N): "
    if /i not "!OVERWRITE!"=="y" (
        echo 已取消
        exit /b 0
    )
)

REM 创建文件内容
(
echo ---
echo date: %DATE%
echo author: %AUTHOR%
echo topic: %TOPIC%
echo tags: []
echo related_files: []
echo status: draft
echo ---
echo.
echo # %TOPIC%
echo.
echo ## 会话背景
echo [描述对话的背景和目的]
echo.
echo ## 关键发现
echo [记录重要的发现和结论]
echo.
echo ### 要点1
echo [详细描述]
echo.
echo ### 要点2
echo [详细描述]
echo.
echo ## 代码示例
echo ```
echo // 如果有代码，在这里添加
echo ```
echo.
echo ## 后续行动
echo - [ ] 待办事项1
echo - [ ] 待办事项2
echo.
echo ## 相关链接
echo - [相关文档]^(^)
echo.
echo ## Claude Code使用
echo [记录使用了哪些Claude Code功能]
echo.
echo ---
echo.
echo **总结**: [一句话总结本次对话的价值]
) > "%FILENAME%"

echo ✅ 创建对话记录: %FILENAME%
echo.
echo 下一步:
echo 1. 编辑文件填写内容
echo 2. cd %REPO_ROOT%
echo 3. git add .
echo 4. git commit -m "feat(conversation): 添加 %TOPIC% by @%AUTHOR%"
echo 5. git push
echo.

REM 尝试用编辑器打开
where code >nul 2>nul
if %errorlevel% equ 0 (
    echo 使用VSCode打开...
    code "%FILENAME%"
) else (
    echo 请手动编辑文件: %FILENAME%
)
