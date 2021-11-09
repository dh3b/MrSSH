@echo off
setlocal enabledelayedexpansion

if /i "%~1"=="-plain" (
    set "PlainString=%~2"
    call:PlainToHex
    exit /b
)
if /i "%~1"=="-hex" (
    set "HexString=%~2"
    call:HexToPlain
    exit /b
)
exit /b

:PlainToHex
echo !PlainString!>PlainText.hex
certutil -encodehex PlainText.hex output.hex >nul
set "HexString="
for /f "delims=" %%A in (output.hex) do (
    set "line=%%A"
    set "line=!line:~5,48!"
    set "HexString=!HexString!!line!"
)
del PlainText.hex output.hex
set "HexString=!HexString: =!"
echo !HexString!

:HexToPlain
echo !HexString!>HexString.hex
certutil -decodehex HexString.hex output.hex >nul
set /p PlainString=<output.hex
del HexString.hex output.hex
echo !PlainString!
