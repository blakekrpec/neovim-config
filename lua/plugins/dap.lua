-- dap.lua: Debug Adapter Protocol configuration
-- Consolidates nvim-dap, nvim-dap-ui, and nvim-dap-virtual-text

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        -- UI for debugging
        {
            "rcarriga/nvim-dap-ui",
            dependencies = { "nvim-neotest/nvim-nio" },
            config = function()
                local dapui = require("dapui")
                dapui.setup()

                -- Auto open/close UI when debugging starts/ends
                local dap = require("dap")
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open()
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close()
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close()
                end
            end,
        },
        -- Inline variable values
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
            },
        },
        -- Mason integration for debug adapters
        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = { "williamboman/mason.nvim" },
            opts = {
                ensure_installed = { "codelldb", "debugpy" },
                automatic_installation = true,
            },
        },
    },
    config = function()
        local dap = require("dap")

        -- Helper: Get path separator and Mason package paths
        local is_windows = vim.fn.has("win32") == 1
        local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
        local python_exe = is_windows and "/venv/Scripts/python" or "/venv/bin/python"
        local codelldb_exe = is_windows and "/extension/adapter/codelldb.exe" or "/extension/adapter/codelldb"

        ---------------------------------------------------------------
        -- Python (debugpy)
        ---------------------------------------------------------------
        dap.adapters.python = {
            type = "executable",
            command = mason_path .. "/debugpy" .. python_exe,
            args = { "-m", "debugpy.adapter" },
        }

        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch File",
                program = "${file}",
                pythonPath = function()
                    -- Use project venv if available, otherwise use debugpy's python
                    local venv = os.getenv("VIRTUAL_ENV")
                    if venv then
                        return venv .. (is_windows and "/Scripts/python" or "/bin/python")
                    end
                    return mason_path .. "/debugpy" .. python_exe
                end,
            },
            {
                type = "python",
                request = "attach",
                name = "Attach to Process",
                connect = {
                    host = "127.0.0.1",
                    port = 5678,
                },
            },
        }

        ---------------------------------------------------------------
        -- C/C++ (codelldb)
        ---------------------------------------------------------------
        dap.adapters.lldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = mason_path .. "/codelldb" .. codelldb_exe,
                args = { "--port", "${port}" },
            },
        }

        local cpp_configs = {
            {
                name = "Launch File",
                type = "lldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
            },
            {
                name = "Launch with Arguments",
                type = "lldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = function()
                    local args_str = vim.fn.input("Arguments: ")
                    return vim.split(args_str, " ", { trimempty = true })
                end,
            },
            {
                name = "Attach to Process",
                type = "lldb",
                request = "attach",
                pid = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
            },
        }

        dap.configurations.cpp = cpp_configs
        dap.configurations.c = cpp_configs

        ---------------------------------------------------------------
        -- C# / Unity (vstuc)
        ---------------------------------------------------------------
        local ok, unity = pcall(require, "unity")
        if ok then
            local unity_endpoint = unity.find_probe()
            if unity_endpoint then
                local vstuc_path = vim.fn.stdpath("data") .. "/vstuc/extension/bin"

                dap.adapters.vstuc = {
                    type = "executable",
                    command = "dotnet",
                    args = { vstuc_path .. "/UnityDebugAdapter.dll" },
                }

                dap.configurations.cs = {
                    {
                        type = "vstuc",
                        request = "attach",
                        name = "Attach to Unity",
                        logFile = vim.fn.stdpath("data") .. "/vstuc.log",
                        projectPath = unity.find_project_path(),
                        endPoint = unity_endpoint,
                    },
                }
            end
        end

        ---------------------------------------------------------------
        -- Signs
        ---------------------------------------------------------------
        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "◐", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
    end,
}
