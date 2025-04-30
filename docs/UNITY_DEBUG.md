[Back to README](../README.md)

**If you are using this neovim-config repo directly, then you only need to do Step 1) below. If you are using this neovim-config to inform you on including Unity Debugging in your own nvim setup, continue on to Step 2).**

Debugging Unity with Neovim is not straightforward, and requires a couple of dlls from Visual Studio Tools for Unity (vstuc). `unity.lua` expects these files in the `nvim-data`. On Windows `nvim-data` is at `~/AppData/Local/nvim-data`, and on Ubuntu it's at `~/.local/share/nvim`. When using this repo, it is currently required to manually download and extract these dlls into your `nvim-data`.

:warning: These instructions install Vistual Stuidio Toolkit for Unity (vstuc) v1.1.0. v1.1.1 and newer target .NET 9.0. If you change the `wget` command below to get `latest` or a version >= 1.1.1 you need to have .NET 9.0 SDK installed.

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

## 2) Add `unity.lua`

This file is needed for debugging as it's `find_probe` method is used to inform the debugger where to attach to Unity (address and port). Place it into your project at least one level higher than `nvim-dap.lua` as the setup for `unity.lua` needs to be ran before it's required in `nvim-dap.lua`.

[Back to README](../README.md)
