@echo off
setlocal

set "API_URL=https://api.anonfiles.com/upload"
set "FILE_PATH=%~1"

if "%FILE_PATH%"=="" (
    echo No file specified. Usage: upload.bat [file_path]
    pause
    exit /b
)

curl --insecure -F "file=@%FILE_PATH%" "%API_URL%" > response.json

set "json_file=response.json"
set "short="
for /f "usebackq tokens=2 delims=: " %%G in (`powershell -Command "(Get-Content '%json_file%' | ConvertFrom-Json).data.file.url.short"`) do set "short=%%~G"
 cls 

color 5
echo | set /p= https:%short%|clip


:next

if "%short%"=="" (
    echo Failed to retrieve the short URL.
    goto :cleanup
)

:cleanup
del response.json

echo #############################################
echo ##                                         ##
echo ##                                         ##
echo ##          COPIED TO CLIPBOARD            ##
echo ##   (https:%short%)    ##
echo ##                                         ##
echo #############################################
pause
