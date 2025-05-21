return
{
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

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
                "Doxygen\\.*", -- Match 'Doxygen' at any point in the path (Windows style)
                "TextMesh Pro\\.*", -- Match 'TextMesh Pro' at any point in the path (Windows style)
                "Build\\.*",   -- Match 'Build' at any point in the path (Windows style)
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
                "Doxygen/.*", -- Match 'Doxygen' at any point in the path (Unix style)
                "TextMesh Pro/.*", -- Match 'TextMesh Pro' at any point in the path (Unix style)
                "Build/.*",   -- Match 'Build' at any point in the path (Unix style)
                "__pycache/", -- Unix style path
                "%.bin$",
                "%.png$",
                "%.git/.*" -- Ignore .git directories and files (Unix style)
            }

        telescope.setup(
            {
                defaults =
                {
                    file_ignore_patterns = ignore_patterns,
                    path_display = { "filename_first" },
                    mappings = {
                        -- i = {                              -- Insert mode mappings
                        --     ["<leader>q"] = actions.close, -- Custom close command
                        -- },
                        n = {                              -- Normal mode mappings
                            ["<leader>q"] = actions.close, -- Custom close command
                        },
                    },
                },
            })
    end,
}
