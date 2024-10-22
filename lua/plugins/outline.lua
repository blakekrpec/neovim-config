return {
    "hedyhli/outline.nvim",
    config = function()
        require("outline").setup({
            outline_window = {
                preview = true,        -- show symbol preview
                auto_close = true,     -- close outline when symbol selected
                width = 25,
                relative_width = true, -- use width as %, not num of cols
                min_width = 25,        -- ensure window is at least this cols wide
            },
            outline_items = {
                show_symbol_lineno = true,
            },
            preview_window = {
                auto_preview = true,
            },
        })
    end,
}
