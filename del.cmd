@echo off
set /p targetDir="Enter the full path of the folder to delete: "

if not exist "%targetDir%" (
    echo Error: Folder does not exist.
    pause
    exit /b
)

echo Deleting...
:: The '> nul' makes it much faster by not printing every file name
del /f /s /q "%targetDir%" > nul
rd /s /q "%targetDir%"

echo Folder Deleted Successfully.
pause
