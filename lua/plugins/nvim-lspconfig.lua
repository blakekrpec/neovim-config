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

        local on_attach = function(client, bufnr)
            -- format on save
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("Format", { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end

            -- keybindings for LSP features
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- rename keybinding
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end

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
                    cmd = { "clangd", "--compile-commands-dir=build" },
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
