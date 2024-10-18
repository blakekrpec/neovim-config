return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
        size = 10,
        open_mapping = [[<leader>t]],
        shading_factor = 2,
        direction = "float",
        float_opts = {
            border = "curved",
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        },
    }) 
    -- Keybinding to close the terminal
    vim.api.nvim_set_keymap('n', '<leader>ct', '<cmd>ToggleTerm<CR>', { noremap = true, silent = true })

  end,
}
