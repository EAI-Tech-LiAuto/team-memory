#!/bin/bash
cd "$(dirname "$0")"
osascript -e 'tell application "Terminal" to do script "cd ~/Desktop/team-memory/scripts && python3 local-server.py"'
