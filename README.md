
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

* Download Neovim:
1. Visit the [Neovim GitHub Releases](https://github.com/neovim/neovim/releases).
2. Download the `nvim-linux64.tar.gz` file from the latest release.

* Extract and Install:
```bash
tar -xzf nvim-linux64.tar.gz
sudo mv nvim-linux64 /usr/local/bin/
sudo ln -s /usr/local/bin/nvim-linux64/bin/nvim /usr/local/bin/nvim
rm nvim-linux64.tar.gz
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

## **Trouble Shooting/Notes**

- [Ubuntu Issues](#ubuntu-issues)
  - [Mason not installing pylsp](#mason-not-installing-pylsp)
  - [Symbols showing as diamonds with question mark](#symbols-showing-as-diamonds-with-question-mark)
- [Windows Issues](#windows-issues)
  - [Mason not finding Python](#mason-not-finding-python)
  - [Symbols showing as diamonds with question mark](#symbols-showing-as-diamonds-with-question-mark-1)
- [ROS2 Issues](#ros2-issues)
  - [Getting clangd LSP working with ROS2](#getting-clangd-lsp-working-with-ros2)

### **Ubuntu Issues**

#### **Mason not installing pylsp**
When trying to run nvim with my config in a docker container, Mason was failing to install the Python lsp. `:MasonLog` reports things are failing with: `Installation failed for Package(name=python-lsp-server) error=spawn: python3 failed with exit code 1 and signal 0.`. The issue seemed to be missing `python3.X-venv` for the installed version of Python. In my case, the docker container contained Python3.10.2, and I needed to `sudo apt install python3.10-venv`.

#### **Symbols showing as diamonds with question mark**
Even with `nvim-web-devicons` installed, if the font used in the Gnome Terminal running nvim does not have a font installed that contains the symbols, then symbols can be displayed as the diamond with a question mark (meaning the installed font doesn't know how to display them).

To fix this, install a Nerd Font on the ubuntu machine:
* Download a Nerd Font: `wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/0xProto.tar.xz` (update version as desired).
* Extract the font: `sudo tar -xf 0xProto.tar.xz -C /usr/share/fonts/`
* Set permissions: `sudo chmod 644 /usr/share/fonts/0xProto*`
* Update the font cache: `sudo fc-cache -fv`
* Close all open terminals.
* Open Gnome Terminal, click the hamburger button, click preferences.
* Create a new profile if you don't already have one. Select the desired profile, then enable "Custom Font", and select "Nerd Font" from the list.

### **Windows Issues**

#### **Mason not finding Python**
Vim is picky about Python on windows. Don't install Python from the windows store, and if you have installed Python from the Windows Store, uninstall it and remove any lingering Python .exes in `C:\<user>\AppData\Local\Microsoft\WindowsApps`. Instead, install Python from [the official Python page](https://www.python.org/downloads/), making sure to select the option to "Add Python to PATH" during installation.

#### **Symbols showing as diamonds with question mark**
Even with `nvim-web-devicons` installed, if the font used in the Windows Terminal, or Windows Powershell, running nvim does not have a font installed that contains the symbols, then symbols can be displayed as the diamond with a question mark (meaning the installed font doesn't know how to display them).

To fix this, install a Nerd Font on the windows machine:

* Download a Nerd Font from [here](https://github.com/ryanoasis/nerd-fonts/releases) (e.g. 0xProto.zip). Extract the .zip, and open the .tff (e.g. 0xProtoNerdFont-Regular.ttf). Click the "Install" button. 

* To check if the Nerd Font is installed, open Control Panel and search for "Fonts." Click "View installed fonts." There, you can search for "nerd" to see if any Nerd Font was installed.

* Open Windows Terminal or Windows PowerShell (whichever you use), click the dropdown (v) next to the new tab (+), and click "Settings." Find Defaults -> Font Face, and then select the newly installed font. Restart the terminal/PowerShell.

### **ROS2 Issues**
#### **Getting clangd LSP working with ROS2**
* To use the included clangd LSP with ROS2 (rclcpp) and other included headers (e.g. opencv2), colcon needs to be told to generate a `compile_commands.json` when building as clang will need this to generate suggestions for included headers (rclcpp, or others like opencv2).
`colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=YES`
