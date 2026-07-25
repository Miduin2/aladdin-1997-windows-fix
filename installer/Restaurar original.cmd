@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Restaurar original.ps1" -GameDirectory "%~dp0"
set "result=%errorlevel%"
echo.
pause
exit /b %result%
