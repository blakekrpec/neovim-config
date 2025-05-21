return {
    'folke/trouble.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts =
    {
        focus = true,
        -- default settings in trouble have <cr> boud to jump, but we want
        -- to bind it to jump_close to close trouble when jumping
        keys = {
            ["<cr>"] = "jump_close",
            ["<2-leftmouse>"] = "jump_close",
        },
        modes =
        {
            lsp_references =
            {
                mode = "lsp_references",
                preview =
                {
                    type = "float",
                    relative = "editor",
                    border = "rounded",
                    title = "Preview",
                     size = {
                        width = 0.5,
                        height = 0.4,
                    },
                    position = { 0.5, 0.5},
                },
                action = function(item, trouble)
                    trouble:jump(item)
                    trouble:close()
                end,
            },
        },
    },
}
