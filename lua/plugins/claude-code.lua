-- Claude Code terminal integration via toggleterm.
-- Only load on Linux/Unix (WSL included). Claude Code requires Node.js and
-- the `claude` CLI to be installed. See README or ask Claude how to install.
if vim.fn.has('win32') == 1 then
    return {}
end

return {
    {
        -- toggleterm is already loaded via toggleterm.lua; this spec just adds
        -- the Claude toggle command on top of it without re-specifying the plugin.
        'akinsho/toggleterm.nvim',
        optional = true,
        config = function()
            local Terminal = require('toggleterm.terminal').Terminal

            local claude = Terminal:new({
                cmd = 'claude',
                dir = 'git_dir',
                direction = 'float',
                float_opts = {
                    border = 'curved',
                    width = function()
                        return math.floor(vim.o.columns * 0.92)
                    end,
                    height = function()
                        return math.floor(vim.o.lines * 0.88)
                    end,
                    highlights = {
                        border = 'Normal',
                        background = 'Normal',
                    },
                },
                -- Start in terminal insert mode automatically
                on_open = function(term)
                    vim.cmd('startinsert!')
                    vim.api.nvim_buf_set_keymap(
                        term.bufnr, 't', '<C-\\>', '<cmd>ClaudeToggle<CR>',
                        { noremap = true, silent = true }
                    )
                end,
                hidden = true,
            })

            vim.api.nvim_create_user_command('ClaudeToggle', function()
                claude:toggle()
            end, { desc = 'Toggle Claude Code terminal' })
        end,
    },
}
