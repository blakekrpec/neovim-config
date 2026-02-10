return {
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require('copilot').setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = '<Tab>',
                        accept_word = false,
                        accept_line = false,
                        next = '<M-]>',
                        prev = '<M-[>',
                        dismiss = '<C-]>',
                    },
                },
                panel = {
                    enabled = true,
                },
            })
        end
    },
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        dependencies = {
            { 'zbirenbaum/copilot.lua' },
            { 'nvim-lua/plenary.nvim' },
        },
        build = 'make tiktoken',
        cmd = {
            'CopilotChat',
            'CopilotChatOpen',
            'CopilotChatToggle',
            'CopilotChatExplain',
            'CopilotChatReview',
            'CopilotChatFix',
            'CopilotChatOptimize',
            'CopilotChatDocs',
            'CopilotChatTests',
        },
        keys = {
            { '<leader>cc', '<cmd>CopilotChatToggle<cr>', desc = 'Toggle Copilot Chat' },
            { '<leader>ce', '<cmd>CopilotChatExplain<cr>', mode = 'v', desc = 'Explain selection' },
            { '<leader>cr', '<cmd>CopilotChatReview<cr>', mode = 'v', desc = 'Review selection' },
            { '<leader>cf', '<cmd>CopilotChatFix<cr>', mode = 'v', desc = 'Fix selection' },
            { '<leader>co', '<cmd>CopilotChatOptimize<cr>', mode = 'v', desc = 'Optimize selection' },
        },
        config = function()
            require('CopilotChat').setup({})
        end
    },
}
