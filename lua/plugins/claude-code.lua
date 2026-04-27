local opts = {
    -- log_level = "debug", -- uncomment to trace WebSocket/MCP messages
    focus_after_send = true,   -- jump to Claude terminal after ClaudeCodeSend
    terminal = {
        split_side = 'right',
        split_width_percentage = 0.40,
        provider = 'native',
        auto_close = true,
    },
    diff_opts = {
        auto_close_on_accept = true,
        layout = 'horizontal',
        keep_terminal_focus = false,
    },
}

return {
    'coder/claudecode.nvim',
    cmd = {
        'ClaudeCode',
        'ClaudeCodeFocus',
        'ClaudeCodeSend',
        'ClaudeCodeTreeAdd',
        'ClaudeCodeAdd',
        'ClaudeCodeDiffAccept',
        'ClaudeCodeDiffDeny',
        'ClaudeCodeSelectModel',
    },
    config = function()
        require('claudecode').setup(opts)
    end,
}