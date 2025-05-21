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

        -- Unity debug
        local vstuc_path          = vim.fn.fnameescape(vim.fn.stdpath('data') ..
            '/vstuc/extension/bin')
        local vstuc_opts          = {
            type = 'vstuc',
            request = 'attach',
            name = 'Attach to Unity',
            logFile = vim.fs.joinpath(vim.fn.stdpath('data')) .. '/vstuc.log',
            projectPath = unity.find_project_path(),
            endPoint = unity.find_probe()
        }

        dap.configurations.cs     = { vstuc_opts }

        dap.adapters.vstuc        = {
            type = 'executable',
            command = 'dotnet',
            args = { vstuc_path .. '/UnityDebugAdapter.dll' },
            name = 'Attach to Unity',
        }

        -- Python debug
        dap.adapters.python       = {
            type = 'executable',
            command = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/Scripts/python', -- Path to Mason's python for debugpy
            args = { '-m', 'debugpy.adapter' },
        }

        dap.configurations.python = {
            {
                type = 'python',
                request = 'launch',
                name = 'Launch File',
                program = "${file}",
                pythonPath = function()
                    return vim.fn.stdpath('data') ..
                        '/mason/packages/debugpy/venv/Scripts/python' -- Path to Mason's python for debugpy
                end,
            },
            {
                type = 'python',
                request = 'attach',
                name = 'Attach to Process',
                connect = {
                    host = '127.0.0.1',
                    port = 5678,
                },
                mode = 'remote',
                pythonPath = function()
                    return vim.fn.stdpath('data') ..
                        '/mason/packages/debugpy/venv/Scripts/python' -- Path to Mason's python for debugpy
                end,
            },
        }

        -- C++ debug
        dap.configurations.cpp    = {
            {
                name = 'Launch File',
                type = 'codelldb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ',
                        vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = vim.fn.getcwd(),
                stopOnEntry = false,
                args = {},
            },
            {
                name = 'Attach to C++ Process',
                type = 'codelldb',
                request = 'attach',
                processId = function()
                    return vim.fn.input('Process ID: ')
                end,
                cwd = vim.fn.getcwd(),
                args = {},
            },
        }

        dap.adapters.codelldb     = {
            type = "server",
            port = "${port}",
            executable = {
                command = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb', -- path to codelldb
                args = { "--port", "${port}" }
            }
        }
    end
}
