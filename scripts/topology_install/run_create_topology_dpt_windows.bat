@echo off
setlocal

if "%~1"=="" goto usage
if "%~2"=="" goto usage
if "%~3"=="" goto usage

set WINCC_OA_BIN=%~1
set PROJECT_NAME=%~2
set SCRIPT_PATH=%~3
set SCRIPT_LIST=%TEMP%\create_topology_dpt.lst

if not exist "%WINCC_OA_BIN%\WCCOActrl.exe" (
  echo ERROR: WCCOActrl.exe not found in "%WINCC_OA_BIN%"
  exit /b 1
)

if not exist "%SCRIPT_PATH%" (
  echo ERROR: script not found "%SCRIPT_PATH%"
  exit /b 1
)

> "%SCRIPT_LIST%" echo %SCRIPT_PATH%

echo Running WinCC OA CTRL script list...
"%WINCC_OA_BIN%\WCCOActrl.exe" -proj "%PROJECT_NAME%" -f "%SCRIPT_LIST%"
set RC=%ERRORLEVEL%

del "%SCRIPT_LIST%" >nul 2>&1

echo Exit code: %RC%
exit /b %RC%

:usage
echo Usage:
echo   run_create_topology_dpt_windows.bat ^<WINCC_OA_BIN^> ^<PROJECT_NAME^> ^<SCRIPT_PATH^>
echo Example:
echo   run_create_topology_dpt_windows.bat "C:\Siemens\Automation\WinCC_OA\3.21\bin" "MyProject" "C:\WinCC_OA_Proj\MyProject\scripts\create_topology_dpt.ctl"
exit /b 1
