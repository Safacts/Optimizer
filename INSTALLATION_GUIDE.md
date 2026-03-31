# DeveloperPerfOptimizer v2.0 - Installation & Distribution Guide

## Quick Start (3 Ways)

### 1️⃣ **Easiest: Use Interactive TUI (No Setup)**

Just run the PowerShell script directly:

```powershell
# Clone repository
git clone https://github.com/Safacts/Optimizer.git
cd Optimizer

# Run interactive UI
.\DevPerf-Interactive.ps1
```

**Features:**
- Beautiful terminal menu interface
- Select optimizations you want
- Preview before applying
- Works on any Windows system
- No installation needed

---

### 2️⃣ **Standalone .EXE (For Non-Technical Users)**

#### **Option A: Build Your Own .EXE (Free)**

**Requirements:**
- PowerShell 5.1+ (built-in on Windows 10+)
- PS2EXE tool (free, open-source)

**Steps:**

1. **Download PS2EXE:**
```powershell
# Open PowerShell as Administrator
$URL = "https://github.com/MScholtes/PS2EXE/raw/master/ps2exe.ps1"
Invoke-WebRequest -Uri $URL -OutFile "$TEMP\ps2exe.ps1"
```

2. **Build the EXE:**
```bash
# From Optimizer directory
.\build-exe.bat
```

This creates: `DeveloperPerfOptimizer-v2.0.exe`

3. **Distribute the .EXE:**
- Give the EXE file to users
- They can double-click to run
- No PowerShell knowledge needed
- Includes interactive menu

#### **Option B: Use Our Pre-Built .EXE (Coming Soon)**

Pre-compiled binaries will be available in GitHub Releases.

---

### 3️⃣ **Professional Installer (Windows .MSI)**

#### **Building the Installer**

**Requirements:**
- NSIS (Nullsoft Installation System) - **FREE**
  - Download: https://nsis.sourceforge.io
  - Install to default location

**Steps:**

1. **Install NSIS:**
   - Download from https://nsis.sourceforge.io/Download
   - Run installer, accept defaults
   - Restart computer (important)

2. **Build installer:**
   ```bash
   # Right-click build-installer.nsi
   # Select "Compile NSIS Script"
   
   # OR from PowerShell:
   & "C:\Program Files (x86)\NSIS\makensis.exe" build-installer.nsi
   ```

   This creates: `DeveloperPerfOptimizer-v2.0-Setup.exe`

3. **Test the installer:**
   ```bash
   .\DeveloperPerfOptimizer-v2.0-Setup.exe
   ```

   This will:
   - Ask for installation location (default: `C:\Program Files\Safacts\DeveloperPerfOptimizer`)
   - Create Start Menu shortcuts
   - Add "Add/Remove Programs" entry
   - Create desktop shortcut

4. **Distribute to users:**
   - Upload `DeveloperPerfOptimizer-v2.0-Setup.exe` to your website
   - Users can download and install like any normal Windows program
   - One-click installation
   - Uninstall via Control Panel

---

## What Users Get

### Interactive TUI Features

```
┌──────────────────────────────────────────────────┐
│    DeveloperPerfOptimizer v2.0 - Interactive TUI │
│              Fast. Safe. Reversible.              │
└──────────────────────────────────────────────────┘

Options:
  [1] Analyze System        - Device diagnostics (no changes)
  [2] Dry Run               - Preview all changes before applying
  [3] Optimize Everything   - Full optimization with 8 phases
  [4] Undo Changes          - Revert everything safely
  [5] About DevPerf         - Information & features
  [6] Exit
```

### What Each Option Does

#### **Analyze System**
- Shows current system specs (OS, CPU, RAM, Disk)
- Lists 8 optimization phases available
- Shows expected performance improvements
- Makes ZERO changes

#### **Dry Run**
- Previews exactly what WILL change
- Shows all modifications by phase
- Explains why each change is safe
- Makes ZERO changes

#### **Optimize Everything**
- Applies all 8 optimization phases:
  1. VS Code Settings (language server memory limits)
  2. Power Plan (High Performance with downclocking)
  3. Defender (add folder exclusions)
  4. GPU Acceleration (hardware rendering)
  5. Git (parallel operations)
  6. Docker (resource allocation)
  7. Disk I/O (NTFS optimization)
  8. Thermal (CPU monitoring)
- Creates timestamped backups
- Shows success/failure for each phase
- About 2-3 minutes total

#### **Undo Changes**
- Restores all original settings from backups
- Reverts every change made
- No data loss
- One-command restoration

---

## Distribution Methods

### For Individual Users
- GitHub Releases (with downloads)
- Direct PowerShell script download
- Pre-built .EXE file

### For Teams / Companies
- Windows installer (`DeveloperPerfOptimizer-v2.0-Setup.exe`)
- Portable EXE (no installation needed)
- Deployment via Microsoft Intune
- Group Policy deployment

### For Linux / macOS
- Direct script download
- Package manager (future: `apt`, `brew`)
- Self-contained binary (future)

---

## File Manifest

```
DeveloperPerfOptimizer-v2.0/
├── Core Scripts:
│   ├── DeveloperPerfOptimizer-v2.ps1          (Windows optimizer)
│   ├── DeveloperPerfOptimizer-macOS.sh        (macOS optimizer)
│   ├── DeveloperPerfOptimizer-Linux.sh        (Linux optimizer)
│   ├── DevPerf-Interactive.ps1                (Interactive TUI)
│   ├── DevPerf-Undo-v2.ps1                    (Windows undo)
│   ├── DevPerf-Undo-macOS.sh                  (macOS undo)
│   └── DevPerf-Undo-Linux.sh                  (Linux undo)
│
├── Build Tools:
│   ├── build-exe.bat                          (Create .EXE from PS1)
│   └── build-installer.nsi                    (Create Windows installer)
│
├── Documentation:
│   ├── README.md                              (Quick start)
│   ├── DEVPERF_GUIDE.md                       (Complete guide)
│   ├── ARCHITECTURE.md                        (Technical design)
│   ├── RELEASE_NOTES_v2.0.md                  (Release summary)
│   ├── INSTALLATION_GUIDE.md                  (This file)
│   └── v2.1-ROADMAP.md                        (Future features)
│
└── License & Misc:
    ├── LICENSE                                (MIT)
    ├── .gitignore
    └── CHANGELOG.md
```

---

## FAQ

### Q: Can non-technical users install this?
**A:** Yes! They can:
1. Download `DeveloperPerfOptimizer-v2.0-Setup.exe`
2. Double-click to install
3. Click "DeveloperPerfOptimizer" in Start Menu
4. Follow the interactive menu

### Q: What if something goes wrong?
**A:** It's 100% reversible:
1. Run "Undo Changes" from the menu
2. Or run `DevPerf-Undo-v2.ps1`
3. Everything returns to original state

### Q: How do I know what will change?
**A:** Use "Dry Run" first:
1. Shows all changes before applying
2. You can review each phase
3. Then decide to proceed or cancel

### Q: Do I need admin?
**A:** Yes, but it's automatic:
- Running the .EXE will prompt for admin if needed
- PowerShell script will warn if not admin
- NSIS installer automatically requests admin

### Q: Can I deploy this to my company?
**A:** Yes!
- Use the Windows installer (.MSI)
- Deploy via Intune
- Or use Group Policy
- All changes are reversible
- IT-safe and auditable

### Q: What about Mac and Linux?
**A:** Both supported:
- macOS: Run `./DeveloperPerfOptimizer-macOS.sh`
- Linux: Run `sudo ./DeveloperPerfOptimizer-Linux.sh`
- Same interactive features coming soon

---

## Building & Distributing (Step-by-Step)

### For Your Own Distribution:

1. **Build .EXE** (for easier distribution):
```bash
./build-exe.bat
# Output: DeveloperPerfOptimizer-v2.0.exe
```

2. **Build Installer** (for professional distribution):
```bash
# Install NSIS first, then:
"C:\Program Files (x86)\NSIS\makensis.exe" build-installer.nsi
# Output: DeveloperPerfOptimizer-v2.0-Setup.exe
```

3. **Upload to GitHub Releases**:
   - Create new release v2.0.0
   - Upload `DeveloperPerfOptimizer-v2.0-Setup.exe`
   - Users can download and install

4. **Share on your website**:
   - Link to Setup.exe
   - Include installation instructions
   - Provide direct script links as fallback

---

## Troubleshooting

### "PowerShell execution policy error"
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "PS2EXE failed to build"
- Ensure PowerShell 5.1+ (`$PSVersionTable`)
- Check internet for PS2EXE download
- Try manual download: https://github.com/MScholtes/PS2EXE

### "NSIS not found"
- Download: https://nsis.sourceforge.io/Download
- Install to default location
- Restart computer
- Try again

### "Need admin privileges"
- Run as Administrator
- Right-click → Run as Administrator
- Installer will request WhenNeeded

---

## Next Steps (v2.1+)

- [ ] Auto-update checking
- [ ] Scheduled optimization
- [ ] Configuration file support
- [ ] Cross-platform package managers
- [ ] GUI application (v3.0)
- [ ] VS Code extension (v3.0)

---

**Questions?** Open an issue on [GitHub](https://github.com/Safacts/Optimizer/issues)

**Last Updated:** March 31, 2026  
**Version:** v2.0.0
