return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        require("neo-tree").setup({
            sources = { "filesystem", "buffers" },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = true,   -- Hide dotfiles
                    hide_gitignored = true, -- Hide files in .gitignore
                    never_show = {          -- List of files or patterns to ignore
                        ".git",
                        "*.tmp",
                        "*.log",
                        "*.meta",
                        "*.asset",
                        "Library",
                    },
                },
                follow_current_file = {
                    enabled = true,          -- Focuses file in the active buffer.
                    leave_dirs_open = false, -- Closes auto expanded dirs.
                },
            },
            buffers = {
                use_icons = true,
                follow_current_file = {
                    enabled = true,          -- Focuses file in the active buffer.
                    leave_dirs_open = false, -- Closes auto expanded dirs.
                },
                show_unloaded = true,
            },
            -- Close Neotree if its the last window open.
            close_if_last_window = true,
            -- Close Neotree on "file_open_requested".
            event_handlers = {
                {
                    event = "file_open_requested",
                    handler = function()
                        require("neo-tree.command").execute({ action = "close" })
                    end
                },
                -- Close Outline if open when neotree is openeing. Otherwise neotre
                -- will open files in Outline window if neotree was opened from
                -- the outline window.
                {
                    event = "neo_tree_window_before_open",
                    handler = function()
                        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                            if vim.bo[buf].filetype == "Outline" then
                                vim.api.nvim_buf_delete(buf, { force = true })
                            end
                        end
                    end,
                },
            },
        })
    end,
}
