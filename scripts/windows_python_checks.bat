@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM Check for Python installation
where python >nul 2>nul
IF ERRORLEVEL 1 (
    echo Python is not installed. Please install Python.
    exit /b 1
)

REM Get Python installation path
FOR /F "delims=" %%i IN ('where python') DO (
    SET "python_path=%%i"
)

REM Get the directory of the Python executable
SET "python_dir=!python_path:python.exe=!"
SET "python_dir=!python_dir:python3.exe=!"

REM Check if Python is in PATH
SET "found=0"
FOR %%j IN ("%PATH:;="% ") DO (
    IF /I "%%j"=="!python_dir!" (
        SET "found=1"
    )
)

IF !found! EQU 0 (
    REM Add Python to PATH
    echo Adding Python to PATH...
    SETX PATH "%PATH%;!python_dir!" >nul
    echo Python has been added to PATH. Please restart your terminal.
) ELSE (
    echo Python is already in PATH.
)

ENDLOCAL
exit /b 0

