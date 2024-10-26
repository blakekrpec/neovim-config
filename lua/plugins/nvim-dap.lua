return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio',
    },
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')
        local unity = require('unity')

        dapui.setup()
        vim.keymap.set('n', '<F5>', function()
            dapui.open()
            dap.continue()
        end)
        vim.keymap.set('n', '<S-F5>', function()
            dapui.close()
            dap.disconnect()
        end)

        -- Unity debug
        local vstuc_path          = vim.fn.fnameescape(vim.fn.stdpath('data') .. '/vstuc/extension/bin')
        local vstuc_opts          = {
            type = 'vstuc',
            request = 'attach',
            name = 'Attach to Unity',
            logFile = vim.fs.joinpath(vim.fn.stdpath('data')) .. '/vstuc.log',
            projectPath = function()
                local path = vim.fn.expand('%:p')
                while true do
                    local new_path = vim.fn.fnamemodify(path, ':h')
                    if new_path == path then
                        return ''
                    end
                    path = new_path
                    local assets = vim.fn.glob(path .. '/Assets')
                    if assets ~= '' then
                        return path
                    end
                end
            end,

            endPoint = function()
                return unity.find_probe() and unity.find_probe().address .. ':' .. unity.find_probe().debuggerPort or ''
            end
        }

        dap.adapters.vstuc        = {
            type = 'executable',
            command = 'dotnet',
            args = { vstuc_path .. '/UnityDebugAdapter.dll' },
            name = 'Attach to Unity',
        }

        dap.configurations.cs     = { vstuc_opts }

        dap.adapters.python       = {
            type = 'executable',
            command = 'python',         -- Use 'python' to rely on PATH
            args = { '-m', 'debugpy.adapter' },
        }

        dap.configurations.python = {
            {
                type = 'python',
                request = 'launch',
                name = 'Launch File',
                program = "${file}", -- This will launch the current file
                pythonPath = function()
                    return 'python'  -- Use 'python' to find the executable in PATH
                end,
            },
            {
                type = 'python',
                request = 'attach',
                name = 'Attach to Process',
                connect = {
                    host = '127.0.0.1',
                    port = 5678, -- Adjust if you're using a different port
                },
                mode = 'remote',
            },
        }
    end
}
