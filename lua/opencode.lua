local M = {}

local _term = nil
local _source_tab = nil

local function get_cmd()
    if vim.fn.executable("opencode") == 1 then
        return "opencode"
    end
    local fallback = vim.fn.expand("~/.opencode/bin/opencode")
    if vim.fn.executable(fallback) == 1 then
        return fallback
    end
    return nil
end

local function not_installed()
    vim.notify("opencode not found — run the Ansible playbook to install it", vim.log.levels.WARN)
end

local function get_term()
    if _term then return _term end
    local cmd = get_cmd()
    if not cmd then return nil end
    local Terminal = require("toggleterm.terminal").Terminal
    
    -- Create a custom Terminal class that sets scrollback before termopen
    local CustomTerminal = setmetatable({}, { __index = Terminal })
    
    -- Override the spawn method to set scrollback BEFORE termopen is called
    function CustomTerminal:spawn()
        -- Create buffer if needed
        if not self.bufnr or not vim.api.nvim_buf_is_valid(self.bufnr) then
            self.bufnr = require("toggleterm.ui").create_buf()
            -- Set scrollback immediately after buffer creation, before termopen
            vim.api.nvim_set_option_value("scrollback", 10000, { buf = self.bufnr })
        end
        -- Call the original spawn method
        Terminal.spawn(self)
    end
    
    local term = Terminal:new({
        cmd = cmd,
        direction = "tab",
        hidden = true,
        env = {
            -- Use custom terminfo that disables alternate screen buffer
            -- This allows scrollback to work properly when resuming sessions
            TERM = "xterm-256color-noaltscreen",
        },
        on_open = function(term)
            -- Enter insert mode when terminal is opened
            vim.cmd("startinsert!")
        end,
    })
    
    -- Apply our custom spawn override
    setmetatable(term, { __index = CustomTerminal })
    _term = term
    return _term
end

local function in_opencode()
    return _term ~= nil
        and _term.bufnr ~= nil
        and vim.api.nvim_get_current_buf() == _term.bufnr
end

-- Switch to the opencode tab, remembering where we came from.
-- Switching tabs never resizes the terminal, so opencode keeps its full
-- scrollback history across every focus round-trip.
local function switch()
    local t = get_term()
    if not t then not_installed(); return end
    if in_opencode() then
        -- Go back to where we came from.
        if _source_tab and _source_tab <= vim.fn.tabpagenr("$") then
            vim.cmd("tabn " .. _source_tab)
        else
            vim.cmd("tabprevious")
        end
    elseif t:is_open() then
        _source_tab = vim.fn.tabpagenr()
        t:focus()
    else
        _source_tab = vim.fn.tabpagenr()
        t:open()
    end
end

M.toggle = switch
M.focus  = switch

-- Ensure scrollback is set for terminal buffers as a safety net
-- This catches any edge cases where the spawn override might not work
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function(args)
        -- Only set for our opencode terminal to avoid affecting other terminals
        if _term and _term.bufnr == args.buf then
            vim.api.nvim_set_option_value("scrollback", 10000, { buf = args.buf })
        end
    end,
})

-- QuitPre fires when user quits, before checking if it's allowed
-- If opencode is open and we to quit, close opencode first
vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        if not _term or not _term:is_open() then return end
        
        -- Check if we quit from a non-opencode buffer
        if not in_opencode() then
            -- Close opencode silently
            pcall(function() _term:shutdown() end)
            if _term.bufnr and vim.api.nvim_buf_is_valid(_term.bufnr) then
                pcall(vim.api.nvim_buf_delete, _term.bufnr, { force = true })
            end
        end
    end,
})

-- ExitPre fires only when nvim is truly exiting and runs before VimLeavePre,
-- so the buffer is gone before auto-session snapshots the layout.
vim.api.nvim_create_autocmd("ExitPre", {
    callback = function()
        if not _term then return end
        pcall(function() _term:shutdown() end)
        if _term.bufnr and vim.api.nvim_buf_is_valid(_term.bufnr) then
            pcall(vim.api.nvim_buf_delete, _term.bufnr, { force = true })
        end
        _term = nil
    end,
})

return M
