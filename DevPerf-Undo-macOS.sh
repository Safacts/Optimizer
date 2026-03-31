#!/usr/bin/env bash
# Developer Performance Optimizer v2.0 - macOS Undo
#
# Reverses all optimizations applied by DeveloperPerfOptimizer-macOS.sh
# Safacts/Optimizer - https://github.com/Safacts/Optimizer
#
# Usage:
#   ./DevPerf-Undo-macOS.sh              # Restore from backups

cd "$(dirname "$0")" || exit 1

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[DevPerf Undo]${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warning() { echo -e "${YELLOW}⚠${NC} $1"; }

BACKUP_DIR="$HOME/.devperf-backups"

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo -e "${RED}✗${NC} No backups found in $BACKUP_DIR"
    exit 1
fi

log "DevPerf Undo - Restoring from backups"

# Restore VS Code settings
if ls "$BACKUP_DIR"/vscode_settings_*.json 1> /dev/null 2>&1; then
    LATEST=$(ls -t "$BACKUP_DIR"/vscode_settings_*.json | head -1)
    VS_CODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
    cp "$LATEST" "$VS_CODE_SETTINGS"
    success "Restored VS Code settings"
fi

# Restore Git config
if ls "$BACKUP_DIR"/git_config_*.txt 1> /dev/null 2>&1; then
    log "Git configuration - manual review recommended"
    warning "Git was reset to default. Review your settings with: git config --global --list"
fi

# Restore power management (defaults)
sudo pmset -c sleep 10
sudo pmset -a hibernatemode 3
success "Restored default power management"

# Restore Docker config
if ls "$BACKUP_DIR"/docker_config_*.json 1> /dev/null 2>&1; then
    LATEST=$(ls -t "$BACKUP_DIR"/docker_config_*.json | head -1)
    if [[ -f "$HOME/.docker/daemon.json" ]]; then
        cp "$LATEST" "$HOME/.docker/daemon.json"
        success "Restored Docker configuration"
        log "Restart Docker Desktop for changes to take effect"
    fi
fi

echo ""
success "Restoration complete!"
log "All optimizations have been reversed"
log "Backups preserved in: $BACKUP_DIR"
