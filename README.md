Clone this repo into `~/.config/` (Ubuntu) or `~/AppData/Local/` (Windows) as `/nvim`

`cd ~/.config`

`git clone git@github.com:blakekrpec/neovim-config.git nvim`

or 

`cd ~/AppData/Local/`

`git clone git@github.com:blakekrpec/neovim-config.git nvim`

## **Warning**
### **Windows Issues**
#### **Mason not finding Python**
Vim is picky about python on windows. Don't install python from the windows store, and if you have installed python from the Windows Store, uninstall it and remove any lingering python .exes in `C:\<user>AppData\Local\Microsoft\WindowsApps`. Instead, install python from [the official python page](https://www.python.org/downloads/), making sure to select the option to "Add Python to PATH" during installation.
#### **Symbols showing as diamonds with question mark**
Even with `nvim-web-devicons` installed, if the font used in the Windows Terminal, or Windows Powershell, running nvim does not have a font installed that contains the symbols, then symbols can be displayed as the diamond with a question mark (meaning the installed font doesn't know how to display them).

To fix this, install a nerd font on the windows machine:

* Download a nerd font from (here)[https://github.com/ryanoasis/nerd-fonts/releases] (e.g. 0xProto.zip). Extract the .zip, and open the .tff (e.g. 0xProtoNerdFont-Regular.ttf). Click the "Install" button. 

* To check if the Nerd Font is installed, open Control Panel and search for "Fonts." Click "View installed fonts." There, you can search for "nerd" to see if any Nerd Font was installed.

* Open Windows Terminal or Windows PowerShell (whichever you use), click the dropdown (v) next to the new tab (+), and click "Settings." Find Defaults -> Font Face, and then select the newly installed font. Restart the terminal/PowerShell.
