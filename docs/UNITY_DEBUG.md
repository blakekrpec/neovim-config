[Back to README](../README.md)

**If you are using this neovim-config repo directly, then you only need to do Step 1) below. If you are using this neovim-config to inform you on including Unity Debugging in your own nvim setup, continue on to Steps 2) and 3).**

Debugging Unity with Neovim is not straightforward, and requires a couple of dlls from Visual Studio Tools for Unity (vstuc). `unity.lua` expects these files in the `nvim-data`. On Windows `nvim-data` is at `~/AppData/Local/nvim-data`, and on Ubuntu it's at `~/.local/share/nvim`. When using this repo, it is currently required to manually download and extract these dlls into your `nvim-data`.

## 1) Download vstuc

#### Windows
```
cd ~/AppData/Local/nvim-data
```
```
wget https://marketplace.visualstudio.com/_apis/public/gallery/publishers/VisualStudioToolsForUnity/vsextensions/vstuc/latest/vspackage -OutFile vstuc.zip
```
```
Expand-Archive -Path .\vstuc.zip -DestinationPath vstuc
```
```
rm  vstuc.zip
```

#### Ubuntu
```
cd ~/.local/share/nvim
```
```
wget -O vstuc.vsix.gz https://marketplace.visualstudio.com/_apis/public/gallery/publishers/VisualStudioToolsForUnity/vsextensions/vstuc/latest/vspackage
```
```
gunzip vstuc.vsix.gz
```
```
unzip vstuc.vsix -d vstuc
```
```
rm vstuc.vsix
```


## 2) Fixing nvim-dap

The new Visual Studio Tools for Unity requires filterOptions be provided for DAP's `setExceptionBreakpoint`, meaning one of `nvim-dap`'s `.lua` files must be modified to include these. To get these changes, point Lazy to use blakekrpec's fork of `nvim-dap`, branch `add-optional-args`. See the following files in this repo where this change was made: [nvim-dap.lua](../lua/plugins/nvim-dap.lua), [nvim-dap-ui.lua](../lua/plugins/nvim-dap-ui.lua), [nvim-dap-virtual-text.lua](../lua/plugins/nvim-dap-virtual-text.lua) . Note, it is slightly different in `nvim-dap.lua` compared to the others.

## 3) Add `unity.lua`

This file is needed for debugging as it's `find_probe` method is used to inform the debugger where to attach to Unity (address and port). Place it into your project at least one level higher than `nvim-dap.lua` as the setup for `unity.lua` needs to be ran before it's required in `nvim-dap.lua`.

[Back to README](../README.md)
