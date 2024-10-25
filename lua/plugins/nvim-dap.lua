return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio',
    },
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')

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
        local vstuc_path      = vim.fn.fnameescape(vim.fn.stdpath('data') .. '/vstuc/extension/bin')
        local vstuc_opts      = {
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
                local system_obj = vim.system({ 'dotnet', vstuc_path .. '/UnityAttachProbe.dll' }, { text = true })
                local probe_result = system_obj:wait(2000).stdout
                if probe_result == nil or #probe_result == 0 then
                    print('No endpoint found, is unity running?')
                    return ''
                end
                for json in vim.gsplit(probe_result, '\n') do
                    if json ~= '' then
                        local probe = vim.json.decode(json)
                        for _, p in pairs(probe) do
                            if p.isBackground == false then
                                return p.address .. ':' .. p.debuggerPort
                            end
                        end
                    end
                end
                return ''
            end
        }
        dap.adapters.vstuc    = {
            type = 'executable',
            command = 'dotnet',
            args = { vstuc_path .. '/UnityDebugAdapter.dll' },
            name = 'Attach to Unity',
        }
        dap.configurations.cs = { vstuc_opts }
    end
}
