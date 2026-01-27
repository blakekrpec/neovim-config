-- mason.lua: Tool installation only
-- LSP configuration is handled separately in lsp.lua

local function notify(msg, level)
    vim.notify(msg, vim.log.levels[level] or vim.log.levels.INFO, { title = "Mason" })
end

local function check_python()
    local is_windows = vim.fn.has("win32") == 1

    if is_windows then
        local result = vim.fn.system("where python 2>NUL")
        if vim.v.shell_error ~= 0 then
            notify("Python not found in PATH. Please install Python and add it to PATH.", "ERROR")
        end
    else
        local result = vim.fn.system("which python3 2>/dev/null")
        if vim.v.shell_error ~= 0 then
            notify("Python3 not found in PATH. Please install python3.", "ERROR")
        end
    end
end

return {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        check_python()

        require("mason").setup({
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        -- mason-lspconfig bridges Mason and nvim-lspconfig
        -- It ensures Mason-installed servers are available to LSP
        require("mason-lspconfig").setup({
            automatic_installation = true,
            ensure_installed = {
                "clangd",
                "cmake",
                "lua_ls",
                "marksman",
                "omnisharp",
                "pylsp",
            },
        })
    end,
}
