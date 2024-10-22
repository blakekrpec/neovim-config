return
{
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        -- Detect the operating system
        local is_windows = vim.loop.os_uname().version:match("Windows")

        -- Set file ignore patterns based on the platform
        local ignore_patterns = is_windows and
            {
                "%.o$",
                "%.dll$",
                "%.meta$",
                "%.tmp$",
                "%.asset$",
                "Library\\.*", -- Match 'Library' at any point in the path (Windows style)
                "__pycache\\", -- Windows style path
                "%.bin$",
                "%.png$",
                "%.git[\\/]?", -- Ignore .git directories and files (Windows style)
            }
            or
            {
                "%.o$",
                "%.dll$",
                "%.meta$",
                "%.asset$",
                "%.tmp$",
                "Library/.*", -- Match 'Library' at any point in the path (Unix style)
                "__pycache/", -- Unix style path
                "%.bin$",
                "%.png$",
                "%.git/.*" -- Ignore .git directories and files (Unix style)
            }

        telescope.setup(
            {
                defaults =
                {
                    file_ignore_patterns = ignore_patterns
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
            local home = vim.loop.os_homedir()
            local nvim_config_path = is_windows and
                (home .. "\\AppData\\Local\\nvim") or
                (home .. "/.config/nvim")

            builtin.find_files(
                {
                    prompt_title = "< NVim Config >",
                    cwd = nvim_config_path, -- Set cwd based on platform
                    hidden = false,     -- Exclude hidden files
                })
        end, { desc = "Fuzzy find Neovim config files" })
    end, -- Ensure this 'end' closes the 'function'
}
