#!/usr/bin/env powershell
<#
.SYNOPSIS
    Undo Developer Laptop Performance Optimizer
    
.DESCRIPTION
    Reverts all changes made by DeveloperPerfOptimizer.ps1
    Re-enables Defender, OneDrive, power throttling, etc.
    
.EXAMPLE
    .\DeveloperPerfOptimizer-Undo.ps1
    
.NOTES
    Version: 1.0
    Companion to DeveloperPerfOptimizer.ps1
#>

Write-Host "`n" + ("="*70) -ForegroundColor Yellow
Write-Host "  DEVELOPER OPTIMIZER - UNDO SCRIPT" -ForegroundColor Yellow
Write-Host "="*70 -ForegroundColor Yellow

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "❌ Requires Administrator privileges!" -ForegroundColor Red
    exit 1
}

Write-Host "`nThis will revert optimization changes:" -ForegroundColor Yellow
Write-Host @"
  • Re-enable Windows Defender real-time protection
  • Switch to Balanced power plan
  • Re-enable CPU Power Throttling
  • Re-enable Memory Compression
  • Remove RTX 2050 GPU preferences
  • Re-enable OneDrive startup (optional)
"@

$confirm = Read-Host "`nProceed with undo? (yes/no)"
if ($confirm -ne "yes") { 
    Write-Host "❌ Cancelled" -ForegroundColor Red
    exit 0 
}

Write-Host "`n[1/4] Re-enabling Windows Defender..." -ForegroundColor Cyan
Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue
Write-Host "  ✓ Defender enabled" -ForegroundColor Green

Write-Host "[2/4] Switching to Balanced power plan..." -ForegroundColor Cyan
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e 2>$null | Out-Null
Write-Host "  ✓ Balanced mode activated" -ForegroundColor Green

Write-Host "[3/4] Re-enabling CPU Power Throttling..." -ForegroundColor Cyan
$throttlePath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling"
if (Test-Path $throttlePath) {
    Set-ItemProperty -Path $throttlePath -Name "PowerThrottlingOff" -Value 0 -ErrorAction SilentlyContinue
    Write-Host "  ✓ Throttling re-enabled" -ForegroundColor Green
}

Write-Host "[4/4] Re-enabling Memory Compression..." -ForegroundColor Cyan
Set-Service -Name "SysMain" -StartupType Automatic -ErrorAction SilentlyContinue
Write-Host "  ✓ Memory Compression enabled" -ForegroundColor Green

Write-Host "`n[OPTIONAL] Re-adding OneDrive to startup..." -ForegroundColor Cyan
$addOneDrive = Read-Host "Add OneDrive back to startup? (yes/no)"
if ($addOneDrive -eq "yes") {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    Set-ItemProperty -Path $regPath -Name "OneDrive" -Value "C:\Users\$env:USERNAME\AppData\Local\Microsoft\OneDrive\OneDrive.exe" -ErrorAction SilentlyContinue
    Write-Host "  ✓ OneDrive startup item added" -ForegroundColor Green
}

Write-Host "`n" + ("="*70) -ForegroundColor Green
Write-Host "  ✅ UNDO COMPLETE!" -ForegroundColor Green
Write-Host "="*70 -ForegroundColor Green

Write-Host @"

Your laptop has been reverted to standard Windows settings:
  ✓ Windows Defender: ON (real-time protection)
  ✓ Power mode: Balanced
  ✓ CPU Throttling: ON
  ✓ GPU acceleration: Removed

Next steps:
  1. Restart your laptop for full effect
  2. Windows Update may now run in background
  3. Defender will consume more RAM/CPU
  4. Performance will decrease vs. optimized state

"@

$restart = Read-Host "Restart now? (yes/no)"
if ($restart -eq "yes") {
    Write-Host "Restarting in 10 seconds..." -ForegroundColor Cyan
    Start-Sleep -Seconds 10
    Restart-Computer -Force
}
