return {
    "hedyhli/outline.nvim",
    config = function()
        require("outline").setup({
            outline_window = {
                preview = true,      -- show symbol preview
                auto_close = true,   -- close outline when symbol selected
                show_numbers = true, -- show numbers in outline window
                width = 25,
                relative_width = true,
            },
            preview_window = {
                auto_preview = true,
            },
        })
    end,
}
