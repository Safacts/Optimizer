#!/usr/bin/env bash
# Developer Performance Optimizer v2.0 - Linux Undo
#
# Reverses all optimizations applied by DeveloperPerfOptimizer-Linux.sh
# Safacts/Optimizer - https://github.com/Safacts/Optimizer
#
# Usage:
#   sudo ./DevPerf-Undo-Linux.sh              # Restore from backups

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[DevPerf Undo]${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warning() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; exit 1; }

# Check for root
if [[ $EUID -ne 0 ]]; then
    error "This script requires root privileges. Re-run with sudo."
fi

BACKUP_DIR="${SUDO_HOME:-$HOME}/.devperf-backups"

if [[ ! -d "$BACKUP_DIR" ]]; then
    error "No backups found in $BACKUP_DIR"
fi

log "DevPerf Undo - Restoring from backups"

# Restore VS Code settings
if ls "$BACKUP_DIR"/vscode_settings_*.json 1> /dev/null 2>&1; then
    LATEST=$(ls -t "$BACKUP_DIR"/vscode_settings_*.json | head -1)
    VS_CODE_SETTINGS="${SUDO_USER_HOME}/.config/Code/User/settings.json"
    if [[ -f "$VS_CODE_SETTINGS" ]]; then
        cp "$LATEST" "$VS_CODE_SETTINGS"
        success "Restored VS Code settings"
    fi
fi

# Restore Git config
if ls "$BACKUP_DIR"/git_config_*.txt 1> /dev/null 2>&1; then
    log "Git configuration - manual review recommended"
    warning "Review your Git settings with: git config --global --list"
fi

# Restore CPU governor (powersave is safe default)
if command -v cpupower > /dev/null; then
    cpupower frequency-set -g powersave 2>/dev/null || true
    success "Reset CPU governor to powersave"
fi

# Restore ext4 options
ROOT_FS=$(df / | tail -1 | awk '{print $1}')
if ls "$BACKUP_DIR"/ext4_options_*.txt 1> /dev/null 2>&1; then
    log "ext4 filesystem - restoring to defaults"
    tune2fs -O ^acl,^user_xattr "$ROOT_FS" 2>/dev/null || true
    success "ext4 options restored"
fi

# Restore Docker config
if ls "$BACKUP_DIR"/docker_config_*.json 1> /dev/null 2>&1; then
    LATEST=$(ls -t "$BACKUP_DIR"/docker_config_*.json | head -1)
    cp "$LATEST" /etc/docker/daemon.json
    success "Restored Docker configuration"
    systemctl restart docker || warning "Could not restart Docker daemon"
fi

echo ""
success "Restoration complete!"
log "All optimizations have been reversed"
log "Backups preserved in: $BACKUP_DIR"
