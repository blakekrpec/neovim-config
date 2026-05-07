return {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup({
            pre_hook = function()
                local ft = vim.bo.filetype
                if ft == 'dockerfile' or ft == 'yaml.docker-compose' or ft == 'make' then
                    return '# %s'
                end
            end,
        })
    end
}
