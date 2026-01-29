return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        { "folke/lazydev.nvim", ft = "lua", opts = {} },
    },
    config = function()
        local util = require("lspconfig.util")

        -- Formatting helpers
        local function find_root(pattern)
            return util.root_pattern(pattern)(vim.api.nvim_buf_get_name(0))
        end

        local function file_contains(filepath, pattern)
            local ok, lines = pcall(vim.fn.readfile, filepath)
            if not ok then return false end
            for _, line in ipairs(lines) do
                if line:match(pattern) then return true end
            end
            return false
        end

        local format_conditions = {
            c = function() return find_root(".clang-format") end,
            cpp = function() return find_root(".clang-format") end,
            cs = function() return find_root(".editorconfig") end,
            lua = function() return find_root(".stylua.toml") or find_root("stylua.toml") end,
            python = function()
                local root = find_root("pyproject.toml")
                if root then
                    local path = root .. "/pyproject.toml"
                    if file_contains(path, "%[tool%.black%]") then return true end
                    if file_contains(path, "%[tool%.ruff%]") then return true end
                end
                return find_root(".flake8")
            end,
        }

        local function should_format(bufnr)
            local ft = vim.bo[bufnr].filetype
            local check = format_conditions[ft]
            return check and check()
        end

        -- on_attach: format-on-save when config exists
        local function on_attach(client, bufnr)
            if not client.server_capabilities.documentFormattingProvider then
                return
            end

            if not should_format(bufnr) then
                client.server_capabilities.documentFormattingProvider = false
                return
            end

            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("LspFormat_" .. bufnr, { clear = true }),
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        async = false,
                        bufnr = bufnr,
                        filter = function(c) return c.id == client.id end,
                    })
                end,
            })
        end


        -- Capabilities (for nvim-cmp integration)
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Server configurations using vim.lsp.config (Neovim 0.11+)
        -- These merge with nvim-lspconfig defaults
        -- Global config applied to all servers
        vim.lsp.config("*", {
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- C/C++
        vim.lsp.config("clangd", {
            cmd = {
                "clangd",
                "--query-driver=/usr/bin/c++,/usr/bin/g++",
                "--completion-style=detailed",
                "--header-insertion=iwyu",
                "--clang-tidy",
            },
            on_attach = on_attach,
        })

        -- Lua
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    completion = { callSnippet = "Replace" },
                    diagnostics = { disable = { "missing-fields" } },
                },
            },
        })

        -- C#
        vim.lsp.config("omnisharp", {
            cmd = { "omnisharp" },
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
                },
            },
        })

        -- Python
        vim.lsp.config("pylsp", {
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = { enabled = false },
                        mccabe = { enabled = false },
                        pyflakes = { enabled = false },
                    },
                },
            },
        })

        -- Enable all configured servers (required in Neovim 0.11+)
        vim.lsp.enable({
            "clangd",
            "neocmakelsp",
            "lua_ls",
            "marksman",
            "omnisharp",
            "pylsp",
        })
    end,
}
