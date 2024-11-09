[Back to README](../README.md)

#### **Symbols showing as diamonds with question mark**
Even with `nvim-web-devicons` installed, if the font used in the Gnome Terminal, or PowerShell, running nvim does not have a font installed that contains the symbols, then symbols can be displayed as the diamond with a question mark (meaning the installed font doesn't know how to display them).

#### Ubuntu
To fix this, install a Nerd Font on the ubuntu machine:
* Download a Nerd Font: `wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/0xProto.tar.xz` (update version as desired).
* Extract the font: `sudo tar -xf 0xProto.tar.xz -C /usr/share/fonts/`
* Remove the tarball: `rm 0xProto.tar.xz`
* Set permissions: `sudo chmod 644 /usr/share/fonts/0xProto*`
* Update the font cache: `sudo fc-cache -fv`
* Close all open terminals.
* Open Gnome Terminal, click the hamburger button, click preferences.
* Create a new profile if you don't already have one. Select the desired profile, then enable "Custom Font", and select "Nerd Font" from the list.

#### Windows
To fix this, install a Nerd Font on the windows machine:

* Download a Nerd Font from [here](https://github.com/ryanoasis/nerd-fonts/releases) (e.g. 0xProto.zip). Extract the .zip, and open the .tff (e.g. 0xProtoNerdFont-Regular.ttf). Click the "Install" button. 

* To check if the Nerd Font is installed, open Control Panel and search for "Fonts." Click "View installed fonts." There, you can search for "nerd" to see if any Nerd Font was installed.

* Open Windows Terminal or Windows PowerShell (whichever you use), click the dropdown (v) next to the new tab (+), and click "Settings." Find Defaults -> Appearance -> Font Face, and then select the newly installed font. Restart the terminal/PowerShell.

[Back to README](../README.md)
