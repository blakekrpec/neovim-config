return {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
        local dap = require('dap')
        if not dap then
            print("Error: dap is nil")
            return
        end

        local is_win32 = vim.fn.has('win32') == 1
        local adapter_path = is_win32 and 'C:\\Program Files\\debuggers\\netcoredbg\\netcoredbg.exe' or
            '/usr/local/debuggers/netcoredbg/netcoredbg'

        print("Adapter path: " .. adapter_path)

        dap.adapters.coreclr = {
            type = 'executable',
            command = adapter_path,
            args = { '--interpreter=vscode' }
        }

        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "Attach to Unity",
                request = "attach",
                processId = require('dap.utils').pick_process,
                -- Make sure the necessary configurations are provided
                -- program = function()
                --     return 'C:\\Users\\blake\\Unity\\GolfTycoon\\Library\\ScriptAssemblies\\Assembly-CSharp.dll'
                -- end
            }
        }

        dap.set_log_level("DEBUG")

        print("Dap setup complete")
    end
}
