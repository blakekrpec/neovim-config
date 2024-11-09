local function notify_user(msg, level)
    level = level or "info" -- Default to "info" level if not specified
    vim.notify(msg, level, { title = "Mason Setup" })
end

local function is_windows()
    return package.config:sub(1, 1) == '\\' -- Check if the OS is Windows
end

local function is_ubuntu()
    local handle = io.popen("lsb_release -is") -- Check if the OS is Ubuntu
    if handle then
        local result = handle:read("*a")
        handle:close()
        return string.find(result, "Ubuntu") ~= nil
    end
    return false
end

local function is_python_installed_windows()
    -- Use cmd to check the Python version
    local handle = io.popen("cmd /c python --version 2>&1")
    if handle then
        local result = handle:read("*a")
        handle:close()
        -- notify_user("Python check output: " .. result, "info")
        return string.find(result, "Python") ~= nil
    end
    return false
end

local function is_python_on_path_windows()
    -- Use cmd to check if Python is in PATH
    local handle = io.popen("cmd /c where python 2>&1") -- 'where' for Windows
    if handle then
        local result = handle:read("*a")
        handle:close()
        -- notify_user("PATH check output: " .. result, "info") -- Debug output
        return result and result ~= ""
    end
    return false
end

local function is_python_installed_ubuntu()
    local handle = io.popen("python3 --version 2>&1")
    if handle then
        local result = handle:read("*a")
        handle:close()
        return string.find(result, "Python") ~= nil
    end
    return false
end

local function is_python_on_path_ubuntu()
    local handle = io.popen("which python3 2>&1") -- 'which' for Ubuntu
    if handle then
        local result = handle:read("*a")
        handle:close()
        return string.find(result, "python3") ~= nil
    end
    return false -- Return false if handle is nil
end

return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        if is_windows() then
            if is_python_installed_windows() then
                if not is_python_on_path_windows() then
                    notify_user("Python is installed but not added to PATH." ..
                        " Please add Python to your PATH.", "error")
                end
            else
                notify_user(
                    "Python installation not found. Please install Python " ..
                    "and add it to your PATH on your Windows system.", "error")
            end
        elseif is_ubuntu() then
            if is_python_installed_ubuntu() then
                if not is_python_on_path_ubuntu() then
                    notify_user("Python is installed but not added to PATH." ..
                        " Please add Python to your PATH.", "error")
                end
            else
                notify_user(
                    "Python installation not found. Please install Python" ..
                    " and add it to your PATH on your Ubuntu system.", "error")
            end
        else
            notify_user("This setup is not on Windows or Ubuntu. Python" ..
                " checks completed.", "error")
        end

        -- Mason setup
        require("mason").setup({
            ensure_installed = {
                "clangd",
                "cmake",
                "codelldb",
                "debugpy",
                "lua_ls",
                "omnisharp",
                "pylsp",
            }
        })

        -- Mason LSP Config setup
        require("mason-lspconfig").setup({
            automatic_installation = true,
            ensure_installed = {
                "clangd",
                "cmake",
                "lua_ls",
                "omnisharp",
                "pylsp",
            },
        })

        -- Mason Tool Installer setup
        require("mason-tool-installer").setup({
            ensure_installed = {
                "clangd",
                "debugpy",
                "codelldb",
                "stylua",
            },
        })
    end,
}
