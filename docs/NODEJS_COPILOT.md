#### **Copilot Chat: "Could not determine Node.js version" / version too old**

`copilot.lua` requires Node.js v22 or newer. Install it via `nvm` (Node Version Manager), the standard Node.js installation method.

---

##### **Install Node.js via nvm**

1. Install `nvm`:
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```

2. Reload your shell:
```bash
source ~/.bashrc
```

3. Install the latest LTS version of Node.js:
```bash
nvm install --lts
```

4. Verify:
```bash
node --version
```

[Back to README](../README.md)
