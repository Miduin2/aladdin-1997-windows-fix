@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Instalar parche.ps1" -GameDirectory "%~dp0"
set "result=%errorlevel%"
echo.
if not "%result%"=="0" echo La instalacion no se completo. No se ha aceptado un ejecutable desconocido.
pause
exit /b %result%
