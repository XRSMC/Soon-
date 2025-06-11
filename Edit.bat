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
powershell -Command "Invoke-WebRequest -Uri <JDK_ZIP_URL> -OutFile '%JDK_ZIP%'"

:: Download SKLauncher
echo Downloading SKLauncher...
powershell -Command "Invoke-WebRequest -Uri <SKLAUNCHER_JAR_URL> -OutFile '%SKL_JAR%'"

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
