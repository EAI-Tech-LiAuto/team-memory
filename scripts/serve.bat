@echo off
REM 本地启动Web服务器脚本（Windows版）
REM 使用方法: serve.bat [port]

set PORT=%1
if "%PORT%"=="" set PORT=8000

echo 🚀 启动团队记忆库Web服务器...
echo 📍 端口: %PORT%
echo 🌐 访问地址: http://localhost:%PORT%
echo.
echo 按 Ctrl+C 停止服务器
echo.

REM 检测可用的服务器
where python >nul 2>nul
if %errorlevel% equ 0 (
    echo 使用 Python...
    python -m http.server %PORT%
    goto :end
)

where php >nul 2>nul
if %errorlevel% equ 0 (
    echo 使用 PHP...
    php -S localhost:%PORT%
    goto :end
)

where node >nul 2>nul
if %errorlevel% equ 0 (
    echo 使用 Node.js http-server...
    npx http-server -p %PORT%
    goto :end
)

echo ❌ 错误: 未找到可用的服务器
echo 请安装以下任一工具：
echo   - Python 3
echo   - PHP
echo   - Node.js
exit /b 1

:end
