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
    local probe_path = vstuc_path .. '/UnityAttachProbe.dll'
    if vim.fn.filereadable(probe_path) == 0 then
        log_to_file("vstuc path not found. Was vstuc downloaded per instructions in docs/UNITY_DEBUG.md?")
        return nil
    end

    local system_obj = vim.system({ 'dotnet', probe_path }, { text = true })
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

-- Generate a .sln for the current Unity project using dotnet CLI
function M.gen_sln()
    if vim.fn.executable('dotnet') == 0 then
        vim.notify('GenUnitySln: dotnet not found in PATH. Install .NET SDK 8+.', vim.log.levels.ERROR)
        return
    end

    local project_path = M.find_project_path()
    if project_path == '' then
        vim.notify('GenUnitySln: not inside a Unity project (no Assets/ directory found)', vim.log.levels.ERROR)
        return
    end

    local existing = vim.fn.glob(project_path .. '/*.sln', false, true)
    vim.list_extend(existing, vim.fn.glob(project_path .. '/*.slnx', false, true))
    if #existing > 0 then
        vim.notify('GenUnitySln: solution already exists: ' .. vim.fn.fnamemodify(existing[1], ':t'), vim.log.levels.WARN)
        return
    end

    local csproj_files = vim.fn.glob(project_path .. '/*.csproj', false, true)
    if #csproj_files == 0 then
        vim.notify(
            'GenUnitySln: no .csproj files found in project root.\n' ..
            'In Unity: Preferences > External Tools > Regenerate Project Files',
            vim.log.levels.ERROR
        )
        return
    end

    local project_name = vim.fn.fnamemodify(project_path, ':t')
    vim.notify('GenUnitySln: creating ' .. project_name .. '.sln...', vim.log.levels.INFO)

    vim.system(
        { 'dotnet', 'new', 'sln', '--name', project_name },
        { text = true, cwd = project_path },
        function(create)
            vim.schedule(function()
                if create.code ~= 0 then
                    vim.notify('GenUnitySln: dotnet new sln failed:\n' .. (create.stderr or ''), vim.log.levels.ERROR)
                    return
                end

                local sln_files = vim.fn.glob(project_path .. '/*.sln', false, true)
                vim.list_extend(sln_files, vim.fn.glob(project_path .. '/*.slnx', false, true))
                if #sln_files == 0 then
                    vim.notify('GenUnitySln: solution file not found after creation', vim.log.levels.ERROR)
                    return
                end

                local add_cmd = { 'dotnet', 'sln', sln_files[1], 'add' }
                vim.list_extend(add_cmd, csproj_files)

                vim.system(add_cmd, { text = true, cwd = project_path }, function(add)
                    vim.schedule(function()
                        if add.code ~= 0 then
                            vim.notify('GenUnitySln: dotnet sln add failed:\n' .. (add.stderr or ''), vim.log.levels.ERROR)
                            return
                        end

                        vim.notify(
                            string.format('GenUnitySln: created %s.sln with %d project(s)', project_name, #csproj_files),
                            vim.log.levels.INFO
                        )

                        for _, client in ipairs(vim.lsp.get_clients({ name = 'omnisharp' })) do
                            vim.lsp.stop_client(client.id)
                        end
                        vim.cmd('edit')
                    end)
                end)
            end)
        end
    )
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

    vim.api.nvim_create_user_command('GenUnitySln', function()
        M.gen_sln()
    end, { desc = 'Generate a .sln for the current Unity project from existing .csproj files' })

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
