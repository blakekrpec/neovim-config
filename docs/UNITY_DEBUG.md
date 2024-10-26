Debugging Unity with Neovim is not straight forward, and requires a couple of dlls from Visual Studio Tools for Unity (vstuc). `unity.lua` expects these files in the `nvim-data`. On Windows `nvim-data` is at `~/AppData/Local/nvim-data`, and on Ubuntu its at `~/.local/share/nvim`. When using this repo, it is currently required to manually download and extract these dlls into your `nvim-data`.

The new Visual Studio Tools for Unity also adds filterOptionsto DAP's `setExceptionBreakpoint`, meaning one of `nvim-dap`s `.lua` files must be modified to include these. Make sure you open neovim at least once so it installs nvim-dap into your `nvim-data` directory.

## Downlaod vstuc

#### Windows
```
cd ~/AppData/Local/nvim-data
wget https://marketplace.visualstudio.com/_apis/public/gallery/publishers/VisualStudioToolsForUnity/vsextensions/vstuc/1.0.4/vspackage -OutFile vstuc.zip
Expand-Archive -Path .\vstuc.zip -DestinationPath vstuc
rm  vstuc.zip
```

#### Ubuntu
```
cd ~/.local/share/nvim
wget -O vstuc.zip https://marketplace.visualstudio.com/_apis/public/gallery/publishers/VisualStudioToolsForUnity/vsextensions/vstuc/1.0.4/vspackage
unzip vstuc.zip -d vstuc
rm vstuc.zip
```


## Modify nivm-dap To Include filterOptions
Open nvim once to ensure that Lazy installs nvim-dap into the `nvim-data` directory. 

Navigate to `nvim-data`.

#### Windows
```
cd ~/AppData/Local/nvim-data
```

#### Ubuntu
```
cd ~/.config/nvim-data
```

Once there, edit [session.lua](https://github.com/mfussenegger/nvim-dap/blob/90616ae6ae40053103dc66872886fc26b94c70c8/lua/dap/session.lua#L995) (line 992 at time of writing) to include filterOptions for`setExceptionBreakpoint`. `seesion.lua is at` nvim-data/lazy/nvim-dap/lua/dap/session.lua`.

Change
```
{ filters - filters, exceptionOptions = exceptionOptions },
```
To
```
{ filters - filters, exceptionOptions = exceptionOptions, filterOptions = {} },
```
