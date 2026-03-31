# DevPerf v2.0 - Undo Script
# Reverts all optimizations applied by DeveloperPerfOptimizer-v2.ps1
#
# This script safely restores your system to its pre-optimization state

#Requires -Version 5.1
#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [string]$BackupDir = $null,
    [switch]$DryRun,
    [switch]$All = $false
)

function Initialize-UndoEnvironment {
    Write-Host "`n════════════════════════════════════════════════════════════"
    Write-Host "  DevPerf v2.0 - Undo Script"
    Write-Host "  System Restoration Utility"
    Write-Host "════════════════════════════════════════════════════════════`n"
    
    # Check admin
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "❌ ERROR: Requires Administrator privileges!" -ForegroundColor Red
        exit 1
    }
    
    # Find latest backup if not specified
    if (-not $BackupDir) {
        $backupParent = "$PSScriptRoot\backups"
        if (Test-Path $backupParent) {
            $BackupDir = Get-ChildItem -Path $backupParent -Directory | Sort-Object CreationTime -Descending | Select-Object -First 1 -ExpandProperty FullName
        }
    }
    
    if (-not $BackupDir -or -not (Test-Path $BackupDir)) {
        Write-Host "❌ ERROR: No backup found to restore!" -ForegroundColor Red
        Write-Host "Specify backup directory with -BackupDir parameter" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "✓ Backup Directory: $BackupDir" -ForegroundColor Green
}

function Undo-VSCodeSettings {
    Write-Host "`n🔧 Restoring VS Code Settings..." -ForegroundColor Cyan
    
    $backupFiles = Get-ChildItem -Path $BackupDir -Filter "settings.json.bak" -ErrorAction SilentlyContinue
    
    foreach ($backup in $backupFiles) {
        $targetPath = $backup.FullName -replace "\.bak$", ""
        $targetParent = Split-Path $targetPath -Parent
        
        if (Test-Path $targetParent) {
            Write-Host "  ✓ Restoring: $targetPath"
            if (-not $DryRun) {
                Copy-Item $backup.FullName $targetPath -Force
            }
        }
    }
}

function Undo-PowerPlan {
    Write-Host "`n⚡ Restoring Power Plan to Balanced..." -ForegroundColor Cyan
    
    if (-not $DryRun) {
        # Get Balanced plan GUID
        $balancedPlan = Get-CimInstance -N root\cimv2\power -Class Win32_PowerPlan | Where-Object ElementName -eq "Balanced"
        if ($balancedPlan) {
            $guid = $balancedPlan.InstanceID -replace 'Microsoft:PowerPlan\\{|\\}', ''
            powercfg /SETACTIVE $guid
            Write-Host "  ✓ Power plan reset to Balanced" -ForegroundColor Green
        }
    }
}

function Undo-DefenderExclusions {
    Write-Host "`n🛡️  Restoring Windows Defender Exclusions..." -ForegroundColor Cyan
    
    if (-not $DryRun) {
        # Remove optimization exclusions
        $exclusions = @(
            "$env:TEMP",
            "$env:LocalAppData\npm-cache",
            "$env:LocalAppData\Yarn",
            "$env:LocalAppData\.npm",
            "C:\ProgramData\chocolatey",
            "$env:HOMEPATH\.nuget",
            "$env:HOMEPATH\.cargo",
            "$env:HOMEPATH\Docker",
            "*/node_modules/*",
            "*/dist/*",
            "*/build/*",
            "*/__pycache__/*",
            "*/venv/*"
        )
        
        foreach ($exclusion in $exclusions) {
            Remove-MpPreference -ExclusionPath $exclusion -ErrorAction SilentlyContinue
        }
        
        Write-Host "  ✓ Defender exclusions removed" -ForegroundColor Green
    }
}

function Undo-GPUAcceleration {
    Write-Host "`n🎮 Removing GPU Acceleration Preferences..." -ForegroundColor Cyan
    
    if (-not $DryRun) {
        $regPath = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"
        if (Test-Path $regPath) {
            Remove-Item -Path $regPath -Force -ErrorAction SilentlyContinue
            Write-Host "  ✓ GPU preferences removed" -ForegroundColor Green
        }
    }
}

function Undo-GitConfig {
    Write-Host "`n📦 Resetting Git Configuration..." -ForegroundColor Cyan
    
    if (-not $DryRun) {
        $configs = @(
            'core.preloadindex',
            'core.maxObjectsInMemory',
            'fetch.parallel',
            'pack.threads',
            'pack.window',
            'receive.unpackLimit'
        )
        
        foreach ($config in $configs) {
            git config --global --unset $config -ErrorAction SilentlyContinue
        }
        
        Write-Host "  ✓ Git config reset" -ForegroundColor Green
    }
}

function Undo-DockerConfig {
    Write-Host "`n🐳 Restoring Docker Configuration..." -ForegroundColor Cyan
    
    $dockerBackup = Get-ChildItem -Path $BackupDir -Filter "docker-settings.json.bak" -ErrorAction SilentlyContinue
    
    if ($dockerBackup) {
        $dockerConfigPath = "$env:AppData\Docker\settings.json"
        Write-Host "  ✓ Restoring Docker settings"
        if (-not $DryRun) {
            Copy-Item $dockerBackup.FullName $dockerConfigPath -Force
        }
    }
}

function Undo-DiskOptimization {
    Write-Host "`n💾 Restoring NTFS Settings..." -ForegroundColor Cyan
    
    if (-not $DryRun) {
        # Re-enable 8dot3name
        fsutil 8dot3name set C: 0 -ErrorAction SilentlyContinue
        
        # Re-enable last access updates
        fsutil behavior set disablelastaccess 0 -ErrorAction SilentlyContinue
        
        Write-Host "  ✓ NTFS settings reset" -ForegroundColor Green
    }
}

function Show-UndoComplete {
    Write-Host "`n════════════════════════════════════════════════════════════"
    Write-Host "  ✅ System Restoration Complete"
    Write-Host "════════════════════════════════════════════════════════════"
    Write-Host "`nAll DevPerf optimizations have been reverted.`n"
    Write-Host "📝 Backup Files Preserved:" -ForegroundColor Cyan
    Write-Host "  $BackupDir`n" -ForegroundColor Cyan
}

# Main execution
function Main {
    Initialize-UndoEnvironment
    
    Write-Host "❓ Restore system to pre-optimization state? (y/n)" -ForegroundColor Yellow
    $confirm = Read-Host
    if ($confirm -ne 'y') {
        Write-Host "Cancelled." -ForegroundColor Yellow
        exit 0
    }
    
    Undo-VSCodeSettings
    Undo-PowerPlan
    Undo-DefenderExclusions
    Undo-GPUAcceleration
    Undo-GitConfig
    Undo-DockerConfig
    Undo-DiskOptimization
    
    Show-UndoComplete
}

Main
