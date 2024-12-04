@echo off
:: Check if PowerShell is available
where powershell >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: PowerShell is not installed or not in the system PATH.
    pause
    exit /b
)

:: Set script path
set scriptPath=%~dp0loggy.ps1

:: Validate if the script exists
if not exist "%scriptPath%" (
    echo Error: The loggy.ps1 script is missing. Please check your installation.
    pause
    exit /b
)

:: Execute the PowerShell script
powershell -ExecutionPolicy Bypass -File "%scriptPath%"
pause