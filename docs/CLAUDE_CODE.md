#### **Claude Code — Setup & Authentication**

This config uses [`coder/claudecode.nvim`](https://github.com/coder/claudecode.nvim) to connect nvim to the `claude` CLI over Anthropic's official IDE extension protocol. Claude can see your current selection, read and edit files, and propose diffs you accept or reject inline.

Node.js v22+ is required — see [NODEJS_COPILOT.md](NODEJS_COPILOT.md).

---

##### **Install**

```bash
npm install -g @anthropic-ai/claude-code
```

The setup script (`scripts/setup.sh`) runs this automatically on Linux.

---

##### **Authenticate**

No credentials belong in this repo — they live outside `~/.config/nvim` and cannot be staged by git.

**Option A — API key** *(works everywhere: Linux, WSL, Docker, SSH)*

Get a key from [console.anthropic.com](https://console.anthropic.com) → API Keys. Add it to your shell rc:

```bash
# ~/.bashrc or ~/.zshrc
export ANTHROPIC_API_KEY="sk-ant-..."
```

Reload your shell, then run `claude` to verify.

**Option B — Browser OAuth** *(for Claude.ai / Pro / Max subscriptions)*

Run `claude` in a terminal. It opens a browser and completes the flow automatically. The token is cached in `~/.claude/`.

On WSL, the browser may not open automatically. Fix it by adding this to `~/.bashrc` so WSL opens URLs in your Windows browser:

```bash
export BROWSER="powershell.exe /c start"
```

> **"Missing client_id" error?** This happens if you paste the auth URL into a browser manually *without* `claude` running. The URL is only valid during the active flow — always start `claude` first, then let it open the browser.

---

##### **Docker**

Install the CLI in the image and mount credentials read-only:

```dockerfile
RUN npm install -g @anthropic-ai/claude-code
```

```yaml
# docker-compose.yml
volumes:
  - $HOME/.claude:/root/.claude:ro
```

Or pass the API key as an env var and skip the mount:

```yaml
environment:
  - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
```

---

##### **Keymaps**

| Key          | Mode   | Action                                 |
| ------------ | ------ | -------------------------------------- |
| `<leader>ac` | normal | Toggle the Claude terminal             |
| `<leader>af` | normal | Focus Claude (no toggle-off)           |
| `<leader>as` | visual | Send selection to Claude as @-mention  |
| `<leader>ab` | normal | Add current buffer to Claude's context |
| `<leader>ay` | normal | Accept Claude's proposed diff          |
| `<leader>an` | normal | Deny Claude's proposed diff            |

[Back to README](../README.md)
