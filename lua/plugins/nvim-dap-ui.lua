return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio"
    },
    config = function()
        local dapui = require("dapui")

        -- Configure DAP UI
        dapui.setup({
            -- Required fields
            element_mappings = {},  -- Default element mappings
            force_buffers = true,   -- Force creation of buffers
            controls = {
                enabled = true,     -- Enable UI controls
                element = "repl",   -- Which element to show controls for
                icons = {
                    pause       = "⏸",
                    play        = "▶",
                    step_over   = "⏭",
                    step_into   = "⏬",
                    step_out    = "⏫",
                    step_back   = "⏪",
                    run_last    = "⟳",
                    terminate   = "⏹",
                    disconnect  = "⏏",
                },
            },

            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },

            mappings = { }, -- not sure if this being empty will cause issues

            -- Expand lines larger than the window
            expand_lines = true,

            layouts = {
                {
                    -- Make left elements wider (variables, watches, etc.)
                    elements = {
                        {
                            id = "scopes",
                            size = 0.45
                        },
                        {
                            id = "breakpoints",
                            size = 0.25
                        },
                        {
                            id = "stacks",
                            size = 0.15
                        },
                        {
                            id = "watches",
                            size = 0.15
                        },
                    },
                    size = 0.35,  -- Increased width of left panel (0.25 is default)
                    position = "left",
                },
                {
                    elements = {
                        {
                            id = "repl",
                            size = 0.5
                        },
                        {
                            id = "console",
                            size = 0.5
                        },
                    },
                    size = 0.25,
                    position = "bottom",
                },
            },

            floating = {
                max_height = nil,
                max_width = nil,
                border = "single",
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },

            windows = { indent = 1 },
            render = {
                indent = 1,            -- Required field for render
                max_type_length = nil, -- Can be set to make variable values display better
                max_value_lines = 100, -- Show more lines for variable values
            }
        })
    end,
}
