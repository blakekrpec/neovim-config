local M = {}

-- Check if vstuc is downloaded
local function find_vstuc()
    local vstuc_path = vim.fn.stdpath('data') .. '/vstuc/extension/bin'
    local probe_dll_path = vstuc_path .. '/UnityAttachProbe.dll'
    local debug_dll_path = vstuc_path .. '/UnityDebugAdapter.dll'

    local probe_dll_exists = vim.fn.filereadable(probe_dll_path) == 1
    local debug_dll_exists = vim.fn.filereadable(debug_dll_path) == 1

    return probe_dll_exists, debug_dll_exists
end

local function log_to_file(msg)
    local log_path = vim.fn.stdpath('data') .. '/unity_probe.log'
    local file = io.open(log_path, 'a')
    if file then
        file:write(os.date('%Y-%m-%d %H:%M:%S') .. ' - ' .. msg .. '\n')
        file:close()
    end
end

-- Finds unity instance to attach to
function M.find_probe()
    local vstuc_path = vim.fn.fnameescape(vim.fn.stdpath('data') .. '/vstuc/extension/bin')
    local system_obj = vim.system({ 'dotnet', vstuc_path .. '/UnityAttachProbe.dll' }, { text = true })
    local probe_result = system_obj:wait(2000).stdout
    if probe_result == nil or #probe_result == 0 then
        log_to_file('No endpoint found (is unity running?)')
        return nil
    end
    for json in vim.gsplit(probe_result, '\n') do
        if json ~= '' then
            local probe = vim.json.decode(json)
            for _, p in pairs(probe) do
                if not p.isBackground then
                    return p.address .. ":" .. p.debuggerPort
                end
            end
        end
    end
    return nil
end

-- Finds the project path
function M.find_project_path()
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
end

-- Send requests to NeovimForUnity Unity package
local function request(tbl)
    local probe = M.find_probe()
    if probe == nil then
        return
    end
    local uv = vim.uv
    local udp = uv.new_udp()
    local json = vim.fn.json_encode(tbl)
    uv.udp_send(udp, json, probe.address, probe.messagerPort, function(err)
        if err then
            print('error:', err)
        else
            uv.close(udp)
        end
    end)
    uv.run()
end

-- Setup user commands
function M.setup()
    local functionTbl = {
        'Refresh',
        'Play',
        'Pause',
        'Unpause',
        'Stop',
    }
    for _, v in ipairs(functionTbl) do
        vim.api.nvim_create_user_command('U' .. v, function()
            request({ Type = v, Value = '' })
        end, {})
    end

    -- Check for DLLs and notify the user
    local found_probe_dll, found_debug_dll = find_vstuc()
    if not found_probe_dll or not found_debug_dll then
        local error_messages = {}
        if not found_probe_dll then
            table.insert(error_messages, 'UnityAttachProbe.dll is missing.')
        end
        if not found_debug_dll then
            table.insert(error_messages, 'UnityDebugAttach.dll is missing.') 
        end
        table.insert(error_messages, 'See docs/UNITY_DEBUG.md for help.')
        -- Concatenate all error messages and log
        log_to_file(table.concat(error_messages, ' '))
    end
end

return M
