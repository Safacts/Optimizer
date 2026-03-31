; DeveloperPerfOptimizer v2.0 - NSIS Installer Script
; 
; Creates a professional Windows installer for DevPerf v2.0
; 
; Requirements:
;   - NSIS (Nullsoft Installation System) - FREE and open-source
;   - Download: https://nsis.sourceforge.io
;   - Install, then drag this file onto MakeNSIS.exe
;
; Output: Creates DeveloperPerfOptimizer-v2.0-Setup.exe

!include "MUI2.nsh"

; Basic settings
Name "DeveloperPerfOptimizer v2.0"
OutFile "DeveloperPerfOptimizer-v2.0-Setup.exe"
InstallDir "$PROGRAMFILES\Safacts\DeveloperPerfOptimizer"
InstallDirRegKey HKCU "Software\Safacts\DevPerf" ""

; Require admin for installation
RequestExecutionLevel admin

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Language
!insertmacro MUI_LANGUAGE "English"

; Installer sections
Section "DeveloperPerfOptimizer v2.0" MainSection
    SetOutPath "$INSTDIR"
    
    ; Core files
    File "DeveloperPerfOptimizer-v2.ps1"
    File "DeveloperPerfOptimizer-macOS.sh"
    File "DeveloperPerfOptimizer-Linux.sh"
    
    ; Undo scripts
    File "DevPerf-Undo-v2.ps1"
    File "DevPerf-Undo-macOS.sh"
    File "DevPerf-Undo-Linux.sh"
    
    ; Interactive UI
    File "DevPerf-Interactive.ps1"
    
    ; Documentation
    File "README.md"
    File "DEVPERF_GUIDE.md"
    File "ARCHITECTURE.md"
    File "RELEASE_NOTES_v2.0.md"
    
    ; Create shortcuts
    SetOutPath "$SMPROGRAMS\DevPerf"
    CreateDirectory "$SMPROGRAMS\DevPerf"
    CreateShortCut "$SMPROGRAMS\DevPerf\DeveloperPerfOptimizer Interactive.lnk" "powershell.exe" '-ExecutionPolicy Bypass -File "$INSTDIR\DevPerf-Interactive.ps1"' "$INSTDIR\DevPerf-Interactive.ps1" 0 SW_SHOW
    CreateShortCut "$SMPROGRAMS\DevPerf\README.lnk" "$INSTDIR\README.md"
    CreateShortCut "$SMPROGRAMS\DevPerf\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
    
    ; Write uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    
    ; Registry
    WriteRegStr HKCU "Software\Safacts\DevPerf" "InstallPath" "$INSTDIR"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\DevPerf" "DisplayName" "DeveloperPerfOptimizer v2.0"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\DevPerf" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\DevPerf" "DisplayVersion" "2.0.0"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\DevPerf" "Publisher" "Safacts"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\DevPerf" "URLInfoAbout" "https://github.com/Safacts/Optimizer"
SectionEnd

Section "Add to Start Menu" StartMenuSection
    ; Already handled in main section
SectionEnd

Section "Create Desktop Shortcut" DesktopSection
    CreateShortCut "$DESKTOP\DevPerf Optimizer.lnk" "powershell.exe" '-ExecutionPolicy Bypass -File "$INSTDIR\DevPerf-Interactive.ps1"' "$INSTDIR\DevPerf-Interactive.ps1" 0 SW_SHOW
SectionEnd

; Descriptions
LangString DESC_MainSection ${LANG_ENGLISH} "Core optimization scripts and documentation"
LangString DESC_StartMenuSection ${LANG_ENGLISH} "Add shortcuts to Start Menu"
LangString DESC_DesktopSection ${LANG_ENGLISH} "Add shortcut to Desktop"

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${MainSection} $(DESC_MainSection)
  !insertmacro MUI_DESCRIPTION_TEXT ${StartMenuSection} $(DESC_StartMenuSection)
  !insertmacro MUI_DESCRIPTION_TEXT ${DesktopSection} $(DESC_DesktopSection)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Uninstaller section
Section "Uninstall"
    Delete "$INSTDIR\DeveloperPerfOptimizer-v2.ps1"
    Delete "$INSTDIR\DeveloperPerfOptimizer-macOS.sh"
    Delete "$INSTDIR\DeveloperPerfOptimizer-Linux.sh"
    Delete "$INSTDIR\DevPerf-Undo-v2.ps1"
    Delete "$INSTDIR\DevPerf-Undo-macOS.sh"
    Delete "$INSTDIR\DevPerf-Undo-Linux.sh"
    Delete "$INSTDIR\DevPerf-Interactive.ps1"
    Delete "$INSTDIR\README.md"
    Delete "$INSTDIR\DEVPERF_GUIDE.md"
    Delete "$INSTDIR\ARCHITECTURE.md"
    Delete "$INSTDIR\RELEASE_NOTES_v2.0.md"
    Delete "$INSTDIR\Uninstall.exe"
    
    RMDir "$INSTDIR"
    RMDir "$SMPROGRAMS\DevPerf"
    
    Delete "$DESKTOP\DevPerf Optimizer.lnk"
    Delete "$SMPROGRAMS\DevPerf\DeveloperPerfOptimizer Interactive.lnk"
    Delete "$SMPROGRAMS\DevPerf\README.lnk"
    Delete "$SMPROGRAMS\DevPerf\Uninstall.lnk"
    
    DeleteRegKey HKCU "Software\Safacts\DevPerf"
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\DevPerf"
SectionEnd

; Installer finished notification
Function .onInstSuccess
    MessageBox MB_ICONINFORMATION|MB_OK "DeveloperPerfOptimizer v2.0 installed successfully!$\n$\nQuick Start:$\n• Click 'DevPerf Optimizer' in Start Menu$\n• Or search 'DevPerf' in your system$\n$\nFor more info, read README.md"
FunctionEnd
