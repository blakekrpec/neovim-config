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
            filesystem = {
                filtered_items = {
                    hide_dotfiles = true,  -- Hide dotfiles
                    hide_gitignored = true,  -- Hide files in .gitignore
                    never_show = { -- List of files or patterns to ignore
                        ".git",
                        "*.tmp",
                        "*.log",
                        "*.meta", 
                    },
                },
            },
        })
    end,
}
