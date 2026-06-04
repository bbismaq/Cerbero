@echo off
REM Cerbero installer launcher for Windows.
REM Just double-click this file. It runs the real installer (install.ps1)
REM in PowerShell, bypassing the default execution policy for this run only.

setlocal
set "SCRIPT_DIR=%~dp0"
echo.
echo ============================================
echo   Cerbero - Windows Installer
echo ============================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%install.ps1"

set "EXITCODE=%ERRORLEVEL%"
echo.
if "%EXITCODE%"=="0" (
    echo Installation finished. You can close this window.
) else (
    echo Installation failed with code %EXITCODE%. Read the messages above.
)
echo.
pause
endlocal
