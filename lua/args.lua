-- args.lua
local M = {}

-- Check for the presence of "--no-session" in the command-line arguments
function M.is_no_session()
    for _, arg in ipairs(vim.v.argv) do
        if arg == "--no-session" then
            vim.cmd("silent! qall")
            vim.cmd("clear")
            return true
        end
    end
    return false
end

return M
