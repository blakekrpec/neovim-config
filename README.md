
- [Setup](#setup)
  - [Install Neovim](#install-neovim)
    - [Ubuntu](#ubuntu)
    - [Windows](#windows)
  - [Configure Neovim](#configure-neovim)
    - [Ubuntu](#ubuntu-1)
    - [Windows](#windows-1)
  - [Open Neovim](#open-neovim)
- [Trouble Shooting/Notes](#trouble-shootingnotes)
## **Setup**

### **Install Neovim**

#### **Ubuntu**

**Option A — Setup script (recommended)**

Clone the repo first, then run the setup script. It installs Neovim, Node.js, python3-venv, unzip, and a Nerd Font in one shot:

```bash
cd ~/.config
git clone git@github.com:blakekrpec/neovim-config.git nvim
bash ~/.config/nvim/scripts/setup.sh
```

Pass `--install-vstuc` if you need Unity debugging support:

```bash
bash ~/.config/nvim/scripts/setup.sh --install-vstuc
```

**Option B — Manual Neovim install only**

```bash
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64 /usr/local/bin/
sudo ln -s /usr/local/bin/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm nvim-linux-x86_64.tar.gz
```

Verify installation:
```
nvim --version
```

> **Note:** With a manual install you'll likely need to install additional dependencies for this config (Node.js, python3-venv, unzip, Nerd Font, etc.). See the [Trouble Shooting/Notes](#trouble-shootingnotes) section below or [`scripts/setup.sh`](scripts/setup.sh) for guidance.

#### **Windows**

**Option A — Setup script (recommended)**

Clone the repo first, then run the setup script. It downloads Neovim directly from the GitHub stable release (guaranteeing 0.10+), installs Node.js via `winget`, and sets up Claude Code and a Nerd Font:

```powershell
cd $env:LOCALAPPDATA
git clone git@github.com:blakekrpec/neovim-config.git nvim
powershell -ExecutionPolicy Bypass -File $env:LOCALAPPDATA\nvim\scripts\setup.ps1
```

Pass `-InstallVstuc` if you need Unity debugging support:

```powershell
powershell -ExecutionPolicy Bypass -File $env:LOCALAPPDATA\nvim\scripts\setup.ps1 -InstallVstuc
```

> **Note:** `winget` ships with Windows 10/11. If it's missing, install **App Installer** from the Microsoft Store.

**Option B — Manual Neovim install only**

* Go to the [Neovim GitHub Releases](https://github.com/neovim/neovim/releases). Download the `nvim-win64.msi` file from the latest release.

* Run the downloaded `nvim-win64.msi` file. Follow the prompts in the installer to complete the installation.

> **Note:** With a manual install you'll likely need to install additional dependencies for this config (Node.js, Claude Code, Nerd Font, etc.). See the [Trouble Shooting/Notes](#trouble-shootingnotes) section below or [`scripts/setup.ps1`](scripts/setup.ps1) for guidance.

### **Configure Neovim**

Clone this repo into `~/.config/` (Ubuntu) or `~/AppData/Local/` (Windows) as `/nvim`

#### **Ubuntu**
`cd ~/.config`

`git clone git@github.com:blakekrpec/neovim-config.git nvim`

#### **Windows**

`cd ~/AppData/Local/`

`git clone git@github.com:blakekrpec/neovim-config.git nvim`

### **Open Neovim**
Open a terminal on Ubuntu, or a Windows Powershell on Windows and enter `nvim`. You can either run nvim from a project directory, or pass the project directory path to `nvim`.

Run `nvim -- --no-session` to start `nvim` with `auto-session` disabled.

## **Trouble Shooting/Notes**

- [Setting Up Unity Debugging](docs/UNITY_DEBUG.md)
- [OmniSharp with Unity (setup & "No .NET SDKs were found")](docs/UNITY_OMNISHARP.md)
- [Symbols Showing as Diamonds with ?](docs/NERD_FONT.md)
- [Mason Not Installing pylsp on Ubuntu ](docs/PYLSP_UBUNTU_ISSUE.md)
- [Mason Not finding Python on Windows](docs/MASON_PYTHON_WINDOWS.md)
- [Getting clangd LSP Working With ROS2](docs/ROS2_CLANGD.md)
- [Mason Not Installing cmake on Windows](docs/MASON_CMAKE_WINDOWS.md)
- [How to Install LLVM on Windows 11](docs/LLVM_WIN11.md)
- [Mason Not Installing on Ubuntu (missing unzip)](docs/MASON_UNZIP_UBUNTU.md)
- [Copilot Chat: Could not determine Node.js version](docs/NODEJS_COPILOT.md)
- [Copilot: Authentication](docs/COPILOT_AUTH.md)
- [Claude Code: Setup & Authentication](docs/CLAUDE_CODE.md)
