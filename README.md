
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

* Download Neovim, and Extract:
```bash
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64 /usr/local/bin/
sudo ln -s /usr/local/bin/nvim-linux_x86-64/bin/nvim /usr/local/bin/nvim
rm nvim-linux-x86_64.tar.gz
```
* Verify installation:
```
nvim --version
```
#### **Windows**

* Go to the [Neovim GitHub Releases](https://github.com/neovim/neovim/releases). Download the `nvim-win64.msi` file from the latest release.

* Run the downloaded `nvim-win64.msi` file. Follow the prompts in the installer to complete the installation.

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
- [Setting Up Omnisharp with Unity](docs/UNITY_OMNISHARP.md)
- [Symbols Showing as Diamonds with ?](docs/NERD_FONT.md)
- [Mason Not Installing pylsp on Ubuntu ](docs/PYLSP_UBUNTU_ISSUE.md)
- [Mason Not finding Python on Windows](docs/MASON_PYTHON_WINDOWS.md)
- [Getting clangd LSP Working With ROS2](docs/ROS2_CLANGD.md)
- [Mason Not Installing cmake on Windows](docs/MASON_CMAKE_WINDOWS.md)
- [How to Install LLVM on Windows 11](docs/LLVM_WIN11.md)
