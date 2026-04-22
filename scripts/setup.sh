#!/usr/bin/env bash
# setup.sh — Ubuntu/Linux setup for blakekrpec/neovim-config
# Run this after cloning the repo to install all required dependencies.
# See docs/ for details on what some of the steps are doing and why. I 
# tired to reference the relevant docs in each section but no promises :).

set -e

INSTALL_VSTUC=false
INSTALL_FONTS=true
for arg in "$@"; do
    case "$arg" in
        --install-vstuc) INSTALL_VSTUC=true ;;
        --no-fonts) INSTALL_FONTS=false ;;
        *) echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

IS_WSL=false
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
fi

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
header()  { echo -e "\n${BOLD}==> $*${RESET}"; }

# ---------------------------------------------------------------------------
# 1. System packages:
# ---------------------------------------------------------------------------
header "Installing system packages (unzip)"
# docs/MASON_UNZIP_UBUNTU.md — Mason requires unzip to install many packages
if dpkg -s unzip &>/dev/null; then
    success "unzip already installed"
else
    sudo apt-get update -qq
    sudo apt-get install -y unzip
    success "unzip installed"
fi

# ---------------------------------------------------------------------------
# 2. python3-venv for the active Python version (required by Mason → pylsp)
# ---------------------------------------------------------------------------
header "Installing python3-venv"
# docs/PYLSP_UBUNTU_ISSUE.md — Mason needs python3.X-venv matching the
# installed Python version to install python-lsp-server.
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null || true)
if [ -z "$PYTHON_VERSION" ]; then
    warn "python3 not found — skipping python3-venv install"
else
    VENV_PKG="python${PYTHON_VERSION}-venv"
    if dpkg -s "$VENV_PKG" &>/dev/null; then
        success "$VENV_PKG already installed"
    else
        sudo apt-get install -y "$VENV_PKG"
        success "$VENV_PKG installed"
    fi
fi

# ---------------------------------------------------------------------------
# 3. Neovim (stable)
# ---------------------------------------------------------------------------
header "Installing Neovim (stable)"
# README.md — download stable release tarball and symlink to /usr/local/bin/nvim
if command -v nvim &>/dev/null; then
    success "nvim already installed: $(nvim --version | head -1)"
else
    NVIM_TARBALL="nvim-linux-x86_64.tar.gz"
    curl -LO "https://github.com/neovim/neovim/releases/download/stable/${NVIM_TARBALL}"
    tar -xzf "$NVIM_TARBALL"
    sudo mv nvim-linux-x86_64 /usr/local/bin/
    sudo ln -sf /usr/local/bin/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    rm "$NVIM_TARBALL"
    success "nvim installed: $(nvim --version | head -1)"
fi

# ---------------------------------------------------------------------------
# 4. Node.js v22+ via nvm (required by copilot.lua)
# ---------------------------------------------------------------------------
header "Installing Node.js via nvm"
# docs/NODEJS_COPILOT.md — copilot.lua requires Node.js v22 or newer.
# Install via nvm so the version can be managed independently of the system.
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if [ ! -d "$NVM_DIR" ]; then
    info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    success "nvm installed"
else
    success "nvm already present at $NVM_DIR"
fi

# Source nvm so we can use it in this script
export NVM_DIR
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

NODE_MAJOR=$(node --version 2>/dev/null | sed 's/v\([0-9]*\).*/\1/' || echo 0)
if [ "$NODE_MAJOR" -ge 22 ] 2>/dev/null; then
    success "Node.js $(node --version) already satisfies v22+ requirement"
else
    info "Installing Node.js LTS (v22+)..."
    nvm install --lts
    nvm use --lts
    success "Node.js $(node --version) installed"
fi

# Persist nvm sourcing in shell rc files if not already present
for RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$RC" ] && ! grep -q 'NVM_DIR' "$RC"; then
        cat >> "$RC" <<'EOF'

# nvm (Node Version Manager) — added by nvim setup.sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
        info "Added nvm init to $RC"
    fi
done

# ---------------------------------------------------------------------------
# 5. Nerd Font (0xProto) — used for fancy icons in nvim
# ---------------------------------------------------------------------------
header "Installing 0xProto Nerd Font"
# docs/NERD_FONT.md — without a Nerd Font installed, icons appear as ◆? diamonds.
# Skip with --no-fonts (e.g. in Docker where there is no display).
if [ "$IS_WSL" = true ]; then
    warn "WSL detected — skipping font install. See the Windows font section in the README if you have not already installed Nerd Font."
elif [ "$INSTALL_FONTS" = false ]; then
    info "Skipping Nerd Font install (--no-fonts)"
else
    FONT_CHECK=$(fc-list 2>/dev/null | grep -i "0xProto" || true)
    if [ -n "$FONT_CHECK" ]; then
        success "0xProto Nerd Font already installed"
    else
        FONT_TARBALL="0xProto.tar.xz"
        wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/${FONT_TARBALL}"
        sudo tar -xf "$FONT_TARBALL" -C /usr/share/fonts/
        rm "$FONT_TARBALL"
        sudo chmod 644 /usr/share/fonts/0xProto* 2>/dev/null || true
        sudo fc-cache -fv &>/dev/null
        success "0xProto Nerd Font installed and font cache updated"
        warn "Restart your terminal and set the font to '0xProto Nerd Font' in terminal preferences"
    fi
fi

# ---------------------------------------------------------------------------
# 6. vstuc dlls — only installed when --install-vstuc flag is passed
# ---------------------------------------------------------------------------
header "Unity Debugging: vstuc dlls"
# docs/UNITY_DEBUG.md — nvim-dap Unity debugging requires two dlls from vstuc.
# Pass --install-vstuc to enable (e.g. in a Unity-specific Dockerfile).
NVIM_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
VSTUC_DIR="$NVIM_DATA/vstuc"

if [ "$INSTALL_VSTUC" = true ]; then
    if [ -d "$VSTUC_DIR" ]; then
        success "vstuc already present at $VSTUC_DIR"
    else
        mkdir -p "$NVIM_DATA"
        cd "$NVIM_DATA"
        wget -q -O vstuc.vsix.gz \
            "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/VisualStudioToolsForUnity/vsextensions/vstuc/1.1.0/vspackage"
        gunzip vstuc.vsix.gz
        unzip -q vstuc.vsix -d vstuc
        rm vstuc.vsix
        cd - > /dev/null
        success "vstuc extracted to $VSTUC_DIR"
    fi
else
    info "Skipping vstuc (pass --install-vstuc to enable)"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
echo -e "${GREEN}${BOLD}Setup complete!${RESET}"
echo ""
