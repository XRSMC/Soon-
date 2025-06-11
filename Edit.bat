@echo off
setlocal enabledelayedexpansion

:: Set working directory
set "WORKDIR=%~dp0SKLauncher"
mkdir "%WORKDIR%"
cd /d "%WORKDIR%"

:: Set filenames
set "JDK_ZIP=jdk.zip"
set "JDK_DIR=jdk"
set "SKL_JAR=SKLauncher.jar"
set "LAUNCHER_BAT=run_sklauncher.bat"
set "SHORTCUT_NAME=SKLauncher.lnk"

:: Download JDK zip
echo Downloading JDK...
powershell -Command "Invoke-WebRequest -Uri https://www.dropbox.com/scl/fi/og1hg34u5iqayrjexkad9/OpenJDK21U-jdk_x64_windows_hotspot_21.0.7_6.zip?rlkey=y98r0w8g7a2p5fxfzz08tpe7n&st=zppbcapd&dl=1 -OutFile '%JDK_ZIP%'"

:: Download SKLauncher
echo Downloading SKLauncher...
powershell -Command "Invoke-WebRequest -Uri https://www.dropbox.com/scl/fi/cyqoio8w1x0akb0qpx21y/SKlauncher-3.2.12.jar?rlkey=l5ea4efugb4f3i28flxmvbtpf&st=1c7l6klm&dl=1 -OutFile '%SKL_JAR%'"

:: Extract JDK zip
echo Extracting JDK...
powershell -Command "Expand-Archive -Path '%JDK_ZIP%' -DestinationPath '%JDK_DIR%'"

:: Delete JDK zip
del "%JDK_ZIP%"

:: Detect JDK folder inside extracted folder
for /d %%f in ("%JDK_DIR%\*") do (
    set "JDK_PATH=%WORKDIR%\%JDK_DIR%\%%~nxf"
    goto :found
)
:found

:: Create launcher batch file
echo Creating launcher batch...
echo @echo off>"%WORKDIR%\%LAUNCHER_BAT%"
echo set JAVA_HOME=%JDK_PATH%>>"%WORKDIR%\%LAUNCHER_BAT%"
echo set PATH=%%JAVA_HOME%%\bin;%%PATH%%>>"%WORKDIR%\%LAUNCHER_BAT%"
echo java -jar "%WORKDIR%\%SKL_JAR%">>"%WORKDIR%\%LAUNCHER_BAT%"

:: Create shortcut on desktop
echo Creating shortcut...
powershell -Command ^
$WshShell = New-Object -ComObject WScript.Shell; ^
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\%SHORTCUT_NAME%"); ^
$Shortcut.TargetPath = '%WORKDIR%\%LAUNCHER_BAT%'; ^
$Shortcut.WorkingDirectory = '%WORKDIR%'; ^
$Shortcut.Save()

echo Installation complete. Use the desktop shortcut to run SKLauncher.
pause
