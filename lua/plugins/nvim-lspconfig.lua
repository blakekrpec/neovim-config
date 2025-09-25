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
                    client.server_capabilities.documentFormattingProvider = false
                    return
                end

                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("Format", { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })
            end
        end

        -- LSP capabilities for autocompletion
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- setup Mason LSPConfig and get installed servers
        mason_lspconfig.setup()

        for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
            local opts = {
                on_attach = on_attach,
                capabilities = capabilities,
            }

            if server == "clangd" then
                opts.cmd = { "clangd" }
                opts.filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" }
                opts.root_dir = util.root_pattern("compile_commands.json", ".git")
                opts.handlers = {
                    ["$/progress"] = function(_, result, ctx)
                        print(result)
                    end,
                }
            elseif server == "lua_ls" then
                -- no extra settings now, but this keeps lua_ls explicitly configured
            elseif server == "omnisharp" then
                opts.cmd = { "omnisharp" }
                opts.settings = {
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
                }
            elseif server == "pylsp" then
                -- no extra settings now, but this keeps pylsp explicitly configured
            end

            nvim_lsp[server].setup(opts)
        end
    end,
}
