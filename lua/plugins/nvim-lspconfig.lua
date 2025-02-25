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

        -- Check if a formatting config file exists
        local function file_exists(filename)
            return vim.fn.filereadable(filename) == 1
        end

        -- Decide if a file type should be formatted
        local function should_format(ft)
            if ft == "cpp" or ft == "c" then
                return file_exists(".clang-format")
            elseif ft == "python" then
                return (file_exists("pyproject.toml") and
                        vim.fn.match(vim.fn.readfile("pyproject.toml"), "tool.black") >= 0)
                    or file_exists(".flake8")
            elseif ft == "cs" then
                return file_exists(".editorconfig")
            elseif ft == "lua" then
                return file_exists(".stylua.toml") or file_exists("stylua.toml")
            end
            return false
        end

        -- on_attach function 
        local on_attach = function(client, bufnr)
            if client.server_capabilities.documentFormattingProvider then
                -- Disable formatting unless explicitly allowed
                local ft = vim.bo[bufnr].filetype
                if not should_format(ft) then
                    print("Disabling LSP formatting for:", ft)
                    client.server_capabilities.documentFormattingProvider = false
                    return
                end

                -- Enable controlled format-on-save
                print("Enabling LSP formatting for:", ft)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("Format", { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        print("Running formatter for:", ft)
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
                    filetypes = { "c", "cpp", "objc", "objcpp" },
                    root_dir = require('lspconfig/util').root_pattern("compile_commands.json", ".git"),
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
            ["omnisharp"] = function()
                nvim_lsp["omnisharp"].setup({
                    cmd = { "omnisharp" },
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
            ["pylsp"] = function()
                nvim_lsp["pylsp"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
        })
    end,
}

