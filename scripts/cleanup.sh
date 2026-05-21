#!/usr/bin/env bash
# cleanup.sh — Clean up all installations made by setup.sh
# This allows you to run setup.sh cleanly again from scratch

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*"; }
header()  { echo -e "\n${BOLD}==> $*${RESET}"; }

echo -e "${BOLD}${RED}WARNING: This will remove installations made by setup.sh${RESET}"
echo ""
echo "This script will:"
echo "  - Uninstall Claude Code CLI (npm global package)"
echo "  - Remove Node.js and nvm (~/.nvm)"
echo "  - Remove Neovim (/usr/local/bin/nvim*)"
echo "  - Remove vstuc data (~/.local/share/nvim/vstuc)"
echo "  - Remove 0xProto Nerd Font (/usr/share/fonts/0xProto*)"
echo ""
echo "This script will NOT remove:"
echo "  - System packages (unzip, python3-venv, dotnet-sdk)"
echo "  - Neovim config (~/.config/nvim)"
echo "  - Neovim data/state/cache directories"
echo ""
read -p "Are you sure you want to continue? (yes/no): " -r
echo
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    info "Cleanup cancelled"
    exit 0
fi

# ---------------------------------------------------------------------------
# 1. Uninstall Claude Code CLI
# ---------------------------------------------------------------------------
header "Uninstalling Claude Code CLI"
if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    
    if command -v npm &>/dev/null; then
        if npm list -g @anthropic-ai/claude-code &>/dev/null; then
            npm uninstall -g @anthropic-ai/claude-code
            success "Claude Code CLI uninstalled"
        else
            info "Claude Code CLI not installed"
        fi
    else
        info "npm not found, skipping"
    fi
else
    info "nvm not found, skipping"
fi

# ---------------------------------------------------------------------------
# 2. Remove nvm and Node.js
# ---------------------------------------------------------------------------
header "Removing nvm and Node.js"
if [ -d "$HOME/.nvm" ]; then
    rm -rf "$HOME/.nvm"
    success "nvm directory removed"
    
    # Remove nvm lines from shell rc files
    for RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [ -f "$RC" ]; then
            # Create a backup
            cp "$RC" "${RC}.backup-$(date +%Y%m%d-%H%M%S)"
            # Remove nvm block
            sed -i '/# nvm (Node Version Manager)/,/bash_completion/d' "$RC"
            info "Removed nvm init from $RC (backup created)"
        fi
    done
else
    info "nvm directory not found"
fi

# ---------------------------------------------------------------------------
# 3. Remove Neovim
# ---------------------------------------------------------------------------
header "Removing Neovim"
if [ -d "/usr/local/bin/nvim-linux-x86_64" ] || [ -L "/usr/local/bin/nvim" ]; then
    sudo rm -rf /usr/local/bin/nvim-linux-x86_64
    sudo rm -f /usr/local/bin/nvim
    success "Neovim removed"
else
    info "Neovim installation not found"
fi

# ---------------------------------------------------------------------------
# 4. Remove vstuc
# ---------------------------------------------------------------------------
header "Removing vstuc"
NVIM_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
VSTUC_DIR="$NVIM_DATA/vstuc"
if [ -d "$VSTUC_DIR" ]; then
    rm -rf "$VSTUC_DIR"
    success "vstuc removed"
else
    info "vstuc not found"
fi

# ---------------------------------------------------------------------------
# 5. Remove 0xProto Nerd Font
# ---------------------------------------------------------------------------
header "Removing 0xProto Nerd Font"
if ls /usr/share/fonts/0xProto* &>/dev/null; then
    sudo rm -f /usr/share/fonts/0xProto*
    sudo fc-cache -fv &>/dev/null
    success "0xProto Nerd Font removed and font cache updated"
else
    info "0xProto Nerd Font not found"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
echo -e "${GREEN}${BOLD}Cleanup complete!${RESET}"
echo ""
echo "You can now run setup.sh again cleanly."
echo ""
echo -e "${YELLOW}Note:${RESET} Restart your terminal or run 'exec bash' to refresh your shell environment"
