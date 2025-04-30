return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        local nvim_lsp = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local util = require("lspconfig.util")

        -- Search for a config file upward from the buffer path
        local function config_exists(pattern)
            local root = util.root_pattern(pattern)(vim.api.nvim_buf_get_name(0))
            return root ~= nil
        end

        -- Determine if formatting should be enabled based on config presence
        local function should_format(ft)
            if ft == "cpp" or ft == "c" then
                return config_exists(".clang-format")
            elseif ft == "python" then
                if config_exists("pyproject.toml") then
                    local root = util.root_pattern("pyproject.toml")(vim.api.nvim_buf_get_name(0))
                    local pyproject_path = root .. "/pyproject.toml"
                    local lines = vim.fn.readfile(pyproject_path)
                    for _, line in ipairs(lines) do
                        if line:match("%[tool%.black%]") then
                            return true
                        end
                    end
                end
                return config_exists(".flake8")
            elseif ft == "cs" then
                return config_exists(".editorconfig")
            elseif ft == "lua" then
                return config_exists(".stylua.toml") or config_exists("stylua.toml")
            end
            return false -- Default to disabling formatting
        end

        -- on_attach function to handle formatting based on config
        local on_attach = function(client, bufnr)
            if client.server_capabilities.documentFormattingProvider then
                local ft = vim.bo[bufnr].filetype
                if not should_format(ft) then
                    -- print("Disabling LSP formatting for:", ft)
                    client.server_capabilities.documentFormattingProvider = false
                    return
                end

                -- print("Enabling LSP formatting for:", ft)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("Format", { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        -- print("Running formatter for:", ft)
                        vim.lsp.buf.format({ async = false })
                    end,
                })
            end
        end

        -- LSP capabilities for autocompletion
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        mason_lspconfig.setup_handlers({
            function(server)
                nvim_lsp[server].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end,
            ["clangd"] = function()
                nvim_lsp["clangd"].setup({
                    cmd = { "clangd" },
                    filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
                    root_dir = util.root_pattern("compile_commands.json", ".git"),
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
            ["lua_ls"] = function()
                nvim_lsp["lua_ls"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
            ["omnisharp"] = function()
                nvim_lsp["omnisharp"].setup({
                    cmd = { "omnisharp" },
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {
                        omnisharp = {
                            fileOptions = {
                                systemExcludeSearchPatterns = {
                                    "**/Library/**",
                                    "**/Temp/**",
                                    "**/Obj/**",
                                    "**/Build/**",
                                    "**/.git/**",
                                },
                            },
                            fileWatchIgnore = {
                                "**/Library/**",
                                "**/Temp/**",
                                "**/Obj/**",
                                "**/Build/**",
                                "**/.git/**",
                            },
                        },
                    },
                })
            end,
            ["pylsp"] = function()
                nvim_lsp["pylsp"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
        })
    end,
}
