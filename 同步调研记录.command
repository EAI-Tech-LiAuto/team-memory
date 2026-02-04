#!/bin/bash
cd "$(dirname "$0")"
osascript -e 'tell application "Terminal" to do script "cd ~/Desktop/team-memory/scripts && ./sync-research.sh && echo \"\" && echo \"按任意键关闭...\" && read"'
