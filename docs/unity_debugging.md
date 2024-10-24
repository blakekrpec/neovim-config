 ## Prerequisites

 Have Unity, and neovim installed.

 ### 1. Install Debugger

You can use the Netcoredbg for both Windows and Ubuntu. Below are the installation steps for both platforms.

#### Ubuntu

```
sudo apt update
sudo apt install -y curl unzip
sudo mkdir -p /usr/local/debuggers/netcoredbg
curl -L https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz -o netcoredbg.tar.gz
sudo tar -xvf netcoredbg.tar.gz -C /usr/local/debuggers/netcoredbg
sudo chmod +x /usr/local/debuggers/netcoredbg/netcoredbg
rm netcoredbg.tar.gz
```
#### Windows

Open a Windows Powershell as Administrator.
```
mkdir 'C:\Program Files\debuggers'
cd 'C:\Program Files\debuggers'
Invoke-WebRequest https://github.com/Samsung/netcoredbg/releases/download/3.1.1-1042/netcoredbg-win64.zip -OutFile netcoredbg.zip
Expand-Archive netcoredbg.zip -DestinationPath "C:\Program Files\debuggers"
```

### 2. Setup Neovim

#### nvim-dap.lua
```
-- nvim-dap setup
local dap = require('dap')

-- Unity uses Netcoredbg for both Ubuntu and Windows
dap.adapters.coreclr = {
    type = 'executable',
    command = vim.fn.has('win32') == 1 and 'C:\\Program Files\\debuggers\\netcoredbg\\netcoredbg.exe' or '/usr/local/debuggers/netcoredbg/netcoredbg',
    args = { '--interpreter=vscode' }  -- Keep the interpreter flag for compatibility
}

-- Configuration for attaching to the Unity Editor
dap.configurations.cs = {
    {
        type = "coreclr",
        name = "Attach to Unity",
        request = "attach",
        processId = require('dap.utils').pick_process,
    }
}

return {
    "mfussenegger/nvim-dap",
    config = function()
        -- Setup the adapter and configurations here
        dap.adapters.coreclr = {
            type = 'executable',
            command = vim.fn.has('win32') == 1 and 'C:\\Program Files\\debuggers\\netcoredbg\\netcoredbg.exe' or '/usr/local/debuggers/netcoredbg/netcoredbg',
            args = { '--interpreter=vscode' }  -- Keep the interpreter flag for compatibility
        }
        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "Attach to Unity",
                request = "attach",
                processId = require('dap.utils').pick_process,
            }
        }
    end
}

```

#### nvim-dap-ui.lua
```
-- nvim-dap-ui setup
return {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
        require("dapui").setup()
    end
}
```

#### nvim-dap-virtual-text.lua
```
-- nvim-dap-virtual-text setup
return {
    "theHamsta/nvim-dap-virtual-text",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
        require("nvim-dap-virtual-text").setup()
    end
}
```

### 3. Attach Neovim to Unity
Open Unity with Mono as the scripting backend (via Project Settings > Player > Configuration > Scripting Backend > Mono).

Attach `nvim-dap` to Unity:

In Neovim, open the C# file you want to debug.

Run the following command in Neovim to start the debugger and attach to Unity
```
:lua require('dap').attach()
```

This will open a process picker to chose the Unity process

### 4. Start Debugging in Neovim

* **Breakpoints** 
    * Set breakpoints in code using: `:lua require('dap').toggle_breakpoint()`.
* **Controls**
    * Start or continue debugging with :lua require('dap').continue().
    * Step over or step into functions with `:lua require('dap').step_over()` and `:lua require('dap').step_into()`.
* UI
    * Use DAP UI by opening panels with `:lua require("dapui").open()` to view variables, stacks, breakpoints, etc.
