#### **Copilot — Authentication**

`copilot.lua` authenticates via GitHub's **device code** flow — no callback URL is involved, so it works on Linux, WSL, and SSH without any extra setup.

Requires an active [GitHub Copilot subscription](https://github.com/features/copilot) and Node.js v22+ (see [NODEJS_COPILOT.md](NODEJS_COPILOT.md)).

---

##### **Authenticate**

Inside nvim run:

```
:Copilot auth
```

It prints a short code (e.g. `ABCD-1234`) and a URL (`github.com/login/device`). Open the URL in any browser, enter the code, and authorize. The plugin detects the grant within a few seconds.

Verify:

```
:Copilot status
```

---

##### **Token storage**

The token is written to `~/.config/github-copilot/` (Linux/WSL) or `%APPDATA%\github-copilot\` (Windows) — outside the nvim config directory and not tracked by this repo's git.

---

##### **Docker**

Mount the token directory read-only:

```yaml
volumes:
  - $HOME/.config/github-copilot:/root/.config/github-copilot:ro
```

[Back to README](../README.md)
