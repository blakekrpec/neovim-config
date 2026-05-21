#!/usr/bin/env bash
# cleanup-opencode-sessions.sh — Clean up OpenCode/Claude sessions and cache
# This removes conversation history, cache, and temporary data

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

# Show what will be cleaned
echo -e "${BOLD}OpenCode Session Cleanup${RESET}"
echo ""
echo "This script will clean up OpenCode sessions and cache data:"
echo ""
echo "  ${BOLD}Session data:${RESET}"
echo "    - ~/.claude/sessions/          (conversation sessions)"
echo "    - ~/.claude/session-env/       (session environment)"
echo "    - ~/.local/share/opencode/storage/  (session storage)"
echo "    - ~/.local/share/opencode/opencode.db*  (session database)"
echo ""
echo "  ${BOLD}Cache data:${RESET}"
echo "    - ~/.claude/cache/             (general cache)"
echo "    - ~/.claude/paste-cache/       (paste cache)"
echo "    - ~/.claude/backups/           (file backups)"
echo "    - ~/.claude/file-history/      (file history)"
echo "    - ~/.claude/shell-snapshots/   (shell snapshots)"
echo ""
echo "  ${BOLD}History:${RESET}"
echo "    - ~/.claude/history.jsonl      (command history)"
echo "    - ~/.local/state/opencode/prompt-history.jsonl  (prompt history)"
echo ""
echo "  ${BOLD}Will NOT remove:${RESET}"
echo "    - ~/.claude/.credentials.json  (your API credentials)"
echo "    - ~/.claude/settings.json      (your settings)"
echo "    - ~/.claude/plugins/           (installed plugins)"
echo "    - ~/.config/opencode/          (opencode config)"
echo ""

# Check sizes before cleanup
CLAUDE_SIZE=$(du -sh ~/.claude 2>/dev/null | cut -f1 || echo "0")
OPENCODE_SHARE_SIZE=$(du -sh ~/.local/share/opencode 2>/dev/null | cut -f1 || echo "0")
OPENCODE_STATE_SIZE=$(du -sh ~/.local/state/opencode 2>/dev/null | cut -f1 || echo "0")

echo "Current sizes:"
echo "  ~/.claude: $CLAUDE_SIZE"
echo "  ~/.local/share/opencode: $OPENCODE_SHARE_SIZE"
echo "  ~/.local/state/opencode: $OPENCODE_STATE_SIZE"
echo ""

read -p "Continue with cleanup? (yes/no): " -r
echo
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    info "Cleanup cancelled"
    exit 0
fi

CLEANED=0

# ---------------------------------------------------------------------------
# 1. Session data
# ---------------------------------------------------------------------------
header "Cleaning session data"

if [ -d ~/.claude/sessions ]; then
    rm -rf ~/.claude/sessions/*
    success "Cleared ~/.claude/sessions"
    ((CLEANED++))
fi

if [ -d ~/.claude/session-env ]; then
    rm -rf ~/.claude/session-env/*
    success "Cleared ~/.claude/session-env"
    ((CLEANED++))
fi

if [ -d ~/.local/share/opencode/storage ]; then
    rm -rf ~/.local/share/opencode/storage/*
    success "Cleared ~/.local/share/opencode/storage"
    ((CLEANED++))
fi

# Remove database files
for dbfile in ~/.local/share/opencode/opencode.db*; do
    if [ -f "$dbfile" ]; then
        rm -f "$dbfile"
        success "Removed $(basename "$dbfile")"
        ((CLEANED++))
    fi
done

# ---------------------------------------------------------------------------
# 2. Cache data
# ---------------------------------------------------------------------------
header "Cleaning cache data"

for cache_dir in cache paste-cache backups file-history shell-snapshots; do
    if [ -d ~/.claude/$cache_dir ]; then
        rm -rf ~/.claude/$cache_dir/*
        success "Cleared ~/.claude/$cache_dir"
        ((CLEANED++))
    fi
done

# ---------------------------------------------------------------------------
# 3. History
# ---------------------------------------------------------------------------
header "Cleaning history"

if [ -f ~/.claude/history.jsonl ]; then
    rm -f ~/.claude/history.jsonl
    success "Removed ~/.claude/history.jsonl"
    ((CLEANED++))
fi

if [ -f ~/.local/state/opencode/prompt-history.jsonl ]; then
    rm -f ~/.local/state/opencode/prompt-history.jsonl
    success "Removed prompt history"
    ((CLEANED++))
fi

# ---------------------------------------------------------------------------
# 4. Optional: Clear logs
# ---------------------------------------------------------------------------
if [ -d ~/.local/share/opencode/log ]; then
    LOG_SIZE=$(du -sh ~/.local/share/opencode/log 2>/dev/null | cut -f1 || echo "0")
    if [ "$LOG_SIZE" != "0" ]; then
        echo ""
        read -p "Also clear logs (~/.local/share/opencode/log, $LOG_SIZE)? (y/n): " -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf ~/.local/share/opencode/log/*
            success "Cleared logs"
            ((CLEANED++))
        fi
    fi
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
if [ $CLEANED -gt 0 ]; then
    echo -e "${GREEN}${BOLD}Cleanup complete!${RESET}"
    echo ""
    echo "Cleaned $CLEANED item(s)"
    echo ""
    
    # Show new sizes
    CLAUDE_SIZE_NEW=$(du -sh ~/.claude 2>/dev/null | cut -f1 || echo "0")
    OPENCODE_SHARE_SIZE_NEW=$(du -sh ~/.local/share/opencode 2>/dev/null | cut -f1 || echo "0")
    OPENCODE_STATE_SIZE_NEW=$(du -sh ~/.local/state/opencode 2>/dev/null | cut -f1 || echo "0")
    
    echo "New sizes:"
    echo "  ~/.claude: $CLAUDE_SIZE_NEW (was $CLAUDE_SIZE)"
    echo "  ~/.local/share/opencode: $OPENCODE_SHARE_SIZE_NEW (was $OPENCODE_SHARE_SIZE)"
    echo "  ~/.local/state/opencode: $OPENCODE_STATE_SIZE_NEW (was $OPENCODE_STATE_SIZE)"
else
    info "Nothing to clean"
fi
echo ""
