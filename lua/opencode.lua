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
        id = 99,  -- avoid collision with the default :ToggleTerm terminal (ID 1)
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

local function shutdown()
    if not _term then return end
    -- Close any windows showing this buffer so the tab disappears before
    -- auto-session snapshots the layout.
    if _term.bufnr and vim.api.nvim_buf_is_valid(_term.bufnr) then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == _term.bufnr then
                pcall(vim.api.nvim_win_close, win, true)
            end
        end
    end
    pcall(function() _term:shutdown() end)
    if _term.bufnr and vim.api.nvim_buf_is_valid(_term.bufnr) then
        pcall(vim.api.nvim_buf_delete, _term.bufnr, { force = true })
    end
    _term = nil
end

-- Exposed so auto-session's pre_save_cmds can call it before snapshotting.
M.shutdown = shutdown

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

-- Belt-and-suspenders: also clean up on ExitPre in case auto-session's
-- pre_save_cmds path is not exercised (e.g. forced exit).
vim.api.nvim_create_autocmd("ExitPre", {
    callback = shutdown,
})

return M
