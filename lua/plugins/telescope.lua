return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()

        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
      
        telescope.setup({
          defaults = {
            fileignorepatterns = {
              "%.o$",
              "%.dll$",
              "%.meta$",
              "%.tmp$",
              "__pycache/",
              "%.bin$",
              "%.png$",
            }
          },
        })

        -- set keymaps
        local keymap = vim.keymap

        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Fuzzy find recent files" })
        keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find string in cwd" })
        keymap.set("n", "<leader>fs", "<cmd>Telescope git_status<cr>", { desc = "Find string under cursor in cwd" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope git commits<cr>", { desc = "Find todos" })

        -- Keybinding to access the .config/nvim directory
        keymap.set("n", "<leader>cn", function()
            builtin.find_files({
                prompt_title = "< NVim Config >",
                cwd = "~/.config/nvim",  -- Adjust to the correct location if needed
                hidden = false           -- Include hidden files
            })
        end, { desc = "Fuzzy find Neovim config files" })
    end,
}
