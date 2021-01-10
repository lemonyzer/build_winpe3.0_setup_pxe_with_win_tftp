@echo off
cls

echo run this script in WAIK - Start the Deployment tools command prompt.
pause

REM Variables
echo Setting variables ...
REM the path to your WAIK installation
set WAIKPath=%ProgramFiles%\Windows AIK
echo Set WAIK directory to %WAIKPath%.
REM possible values are: x86, amd64 and ia64
set ARCH=amd64
echo Set architecture to %ARCH%.
set PEPath=C:\winpe_%ARCH%
echo Set temporary working directory for Windows PE to %PEPath%.
set TFTPPath=C:\tftp\Boot
echo Set TFTP boot directory to %TFTPPath%.
REM Don't change this one!
REM FIX: winpe.wim needs same name as in BCD osdevice setted 
set WIMFileName=winpe_%ARCH%.wim
echo Set WIM-Filename to %WIMFileName%.
REM Don't change this one!
set BCDStore=%TFTPPath%\BCD
echo Set BCD store to %BCDStore%.
echo All variables set!
echo.

REM Environment check
echo Checking for clean environment...
if not exist "%WAIKPATH%" set NoWAIK=1 && goto :end
if not exist "%WAIKPath%\Tools\PETools\%ARCH%" set NoARCH=1 && goto :end
if exist %PEPath% echo Temporary working directory not empty! Need to remove && rd %PEPath% /S
if exist %PEPath% echo Temporary working directory still not empty! Trying again ... && cd "%WAIKPath%\Tools\%ARCH%" && imagex /unmount %PEPath%\mount && rd %PEPath% /S /Q
if exist %PEPath% set NotClean=1 && goto :end
if exist %TFTPPath% echo TFTP boot directory not empty! Need to remove && rd %TFTPPath% /S
if exist %TFTPPath% set NotClean=1 && goto :end
if exist %BCDStore% echo BCD store existing! Need to remove && del /P %BCDStore%
if exist %BCDStore% set NotClean=1 && goto :end
echo.

REM WORK!
echo Starting real work now ...
cd "%WAIKPath%\Tools\PETools"
echo Copying PE-Files ...
call copype %ARCH% %PEPath%
REM FIX: rename winpe.wim to target-name %WIMFileName%
move %PEPath%\winpe.wim %PEPath%\%WIMFileName% > NUL
echo Mounting Windows PE image ...
imagex /mountrw %PEPath%\%WIMFileName% 1 %PEPath%\mount
md %TFTPPath% > NUL
copy %PEPath%\mount\Windows\Boot\PXE\*.* %TFTPPath% > NUL
copy "%WAIKPath%\Tools\PETools\%ARCH%\boot\boot.sdi" %TFTPPath% > NUL
copy %PEPath%\%WIMFileName% %TFTPPath% > NUL
cd %PEPath%\mount\Windows\System32
bcdedit -createstore %BCDStore%
bcdedit -store %BCDStore% -create {ramdiskoptions} /d "Ramdisk options"
bcdedit -store %BCDStore% -set {ramdiskoptions} ramdisksdidevice  Boot
bcdedit -store %BCDStore% -set {ramdiskoptions} ramdisksdipath  \Boot\boot.sdi
for /f "Tokens=3" %%i in ('bcdedit /store %BCDStore% /create /d "Windows 7 Install Image" /application osloader') do set GUID=%%i
bcdedit -store %BCDStore% -set %GUID% systemroot \Windows
bcdedit -store %BCDStore% -set %GUID% detecthal Yes
bcdedit -store %BCDStore% -set %GUID% winpe Yes
bcdedit -store %BCDStore% -set %GUID% osdevice ramdisk=[boot]\Boot\%WIMFileName%,{ramdiskoptions}
bcdedit -store %BCDStore% -set %GUID% device ramdisk=[boot]\Boot\%WIMFileName%,{ramdiskoptions}
bcdedit -store %BCDStore% -create {bootmgr} /d "Windows 7 Boot Manager"
bcdedit -store %BCDStore% -set {bootmgr} timeout 30
bcdedit -store %BCDStore% -set {bootmgr} displayorder %GUID%
bcdedit -store %BCDStore%
cd c:\
imagex /unmount %PEPath%\mount
echo.
echo FIX: copy %TFTPPath%\pxeboot.n12 to pxeboot.0
copy %TFTPPath%\pxeboot.n12 %TFTPPath%\pxeboot.0
echo FIX: copy %TFTPPath%\bootmgr.exe to %TFTPPath%\..\bootmgr.exe 
copy %TFTPPath%\bootmgr.exe %TFTPPath%\..\bootmgr.exe
pause
goto :exit

:end
if %NoWAIK%=1 echo "Your WAIK directory was not found. Execution aborted." && pause && goto :exit
if %NoARCH%=1 echo "Your Architecture doesn't seem to be right. Or at least it is not known by your WAIK installation. Execution aborted." && pause && goto :exit
if %NotClean%=1 echo "Your environment was not clean. Execution aborted." && pause && goto :exit

:exit