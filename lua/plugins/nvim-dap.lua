return {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
        local dap = require('dap')
        -- Setup the adapter and configurations

        dap.adapters.coreclr = {
            type = 'executable',
            command = vim.fn.has('win32') == 1 and 'C:\\debuggers\\netcoredbg\\netcoredbg.exe' or
                '/usr/local/debuggers/netcoredbg/netcoredbg',
            args = { '--interpreter=vscode' } -- Keep the interpreter flag for compatibility
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
