@echo off
REM DeveloperPerfOptimizer v2.0 - PS2EXE Builder
REM Creates a standalone .EXE from the interactive PowerShell script
REM
REM Requirements: PS2EXE (free, open-source)
REM Download: https://github.com/MScholtes/PS2EXE
REM
REM Usage: Run as Administrator
REM     build-exe.bat

setlocal enabledelayedexpansion

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║        DeveloperPerfOptimizer v2.0 - EXE Builder           ║
echo ║              Converting PowerShell to .EXE                 ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ This script requires Administrator privileges!
    echo.
    echo Right-click Command Prompt or PowerShell and select "Run as Administrator"
    pause
    exit /b 1
)

REM Define paths
set SOURCE_PS1=DevPerf-Interactive.ps1
set OUTPUT_EXE=DeveloperPerfOptimizer-v2.0.exe
set PS2EXE_TOOL=%TEMP%\PS2EXE\ps2exe.ps1

REM Check if source file exists
if not exist "%SOURCE_PS1%" (
    echo ❌ Error: %SOURCE_PS1% not found!
    echo.
    echo Make sure you're running this from the Optimizer directory.
    pause
    exit /b 1
)

echo ✓ Source file: %SOURCE_PS1%
echo ✓ Output file: %OUTPUT_EXE%
echo.

REM Check if PS2EXE is installed
if not exist "%PS2EXE_TOOL%" (
    echo Installing PS2EXE...
    echo.
    
    REM Create temp directory
    if not exist "%TEMP%\PS2EXE" mkdir "%TEMP%\PS2EXE"
    
    REM Download PS2EXE (using PowerShell)
    powershell -Command "& {$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/MScholtes/PS2EXE/raw/master/ps2exe.ps1' -OutFile '%PS2EXE_TOOL%'}" >nul 2>&1
    
    if !errorlevel! neq 0 (
        echo ⚠️  Could not auto-download PS2EXE
        echo.
        echo Manual Installation:
        echo 1. Download from: https://github.com/MScholtes/PS2EXE/releases
        echo 2. Extract ps2exe.ps1 to: %PS2EXE_TOOL%
        echo 3. Run this script again
        pause
        exit /b 1
    )
    echo ✓ PS2EXE installed
    echo.
)

echo 🔧 Converting PowerShell to .EXE...
echo.

REM Run PS2EXE to convert script to EXE
powershell -NoProfile -ExecutionPolicy Bypass -Command "& {param(^$ScriptPath, ^$OutputPath) . '%PS2EXE_TOOL%' -inputFile '%SOURCE_PS1%' -outputFile '%OUTPUT_EXE%' -title 'DeveloperPerfOptimizer v2.0' -iconFile $null -requireAdmin}" -ScriptPath "%SOURCE_PS1%" -OutputPath "%OUTPUT_EXE%"

if %errorlevel% equ 0 (
    echo.
    echo ✅ Success! Created: %OUTPUT_EXE%
    echo.
    echo 📦 Distribution:
    echo   1. Copy %OUTPUT_EXE% to your installation directory
    echo   2. Create a simple installer with NSIS (free, open-source)
    echo   3. Users can double-click to run (no PowerShell knowledge needed)
    echo.
    echo 🚀 Next Steps:
    echo   1. Test the EXE: .\%OUTPUT_EXE%
    echo   2. Create installer using build-installer.nsi
    echo.
) else (
    echo.
    echo ❌ Conversion failed. Check errors above.
    echo.
    echo Troubleshooting:
    echo   - Ensure PS2EXE downloaded correctly
    echo   - Check internet connection
    echo   - Try manual download: https://github.com/MScholtes/PS2EXE
    pause
    exit /b 1
)

pause
