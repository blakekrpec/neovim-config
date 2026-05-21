local o = vim.opt

o.autoindent = true         -- Copy indent from current line when starting a new line.
o.clipboard = "unnamedplus" -- uses the clipboard register for all operations except yank.
o.colorcolumn = "80"        -- highlight col 80
o.cursorline = true         -- Highlight the screen line of the cursor with CursorLine.
o.encoding = "UTF-8"        -- Sets the character encoding used inside Vim.
o.expandtab = true          -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
o.hidden = true             -- When on a buffer becomes hidden when it is |abandon|ed
o.inccommand =
"split"                     -- When nonempty, shows the effects of :substitute, :smagic, :snomagic and user commands with the :command-preview flag as you type.
o.mouse = "a"               -- Enable the use of the mouse. "a" you can use on all modes
o.number = true             -- Print the line number in front of each line
o.relativenumber = true     -- Show the line number relative to the line with the cursor in front of each line.
o.ruler = true              -- Show the line and column number of the cursor position, separated by a comma.
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages," ..
    "winsize,winpos,terminal,localoptions"
o.shiftwidth = 4   -- Number of spaces to use for each step of (auto)indent.
o.showcmd = true   -- Show (partial) command in the last line of the screen. Set this option off if your terminal is slow.
o.showmatch = true -- When a bracket is inserted, briefly jump to the matching one.
o.smartindent = true
o.splitright = true
o.splitbelow = true -- When on, splitting a window will put the new window below the current one
o.syntax = "on"     -- When this option is set, the syntax with this name is loaded.
o.tabstop = 4       -- Number of spaces that a <Tab> in the file counts for.
o.termguicolors = true
o.title = true      -- When on, the title of the window will be set to the value of 'titlestring'
-- Setting ttimeoutlen too low caused wierd auto_session state restoration in WSL. Used to use 0, but had to 
-- go up to 5 to resort that issues.
o.ttimeoutlen = 5   -- The time in milliseconds that is waited for a key code or mapped key sequence to complete.
o.wildmenu = true   -- When 'wildmenu' is on, command-line completion operates in an enhanced mode.
o.wrap = false
o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,t:ver25"
o.autoread = true  -- reload files changed outside nvim

o.clipboard = "unnamed"

-- Set global terminal scrollback buffer size
vim.g.terminal_scrollback_buffer_size = 100000

-- Check for external file changes whenever nvim regains focus or a buffer is entered.
-- autoread alone won't fire without this trigger.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    pattern = "*",
    command = "checktime",
})

-- Prevents :q from failing with "unsaved changes" when opening nvim with no file
-- and accidentally trying to modifying the blank no name buffer.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
      vim.bo.modifiable = false
    end
  end,
})

vim.filetype.add({
    filename = {
        ["docker-compose.yml"]  = "yaml.docker-compose",
        ["docker-compose.yaml"] = "yaml.docker-compose",
        ["compose.yml"]         = "yaml.docker-compose",
        ["compose.yaml"]        = "yaml.docker-compose",
    },
    pattern = {
        ["docker-compose%..*%.yml"]  = "yaml.docker-compose",
        ["docker-compose%..*%.yaml"] = "yaml.docker-compose",
    },
})
