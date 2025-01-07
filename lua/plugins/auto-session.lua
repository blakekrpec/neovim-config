local args = require("args")

-- check if the --no-session flag is passed
local no_session = args.is_no_session()

return {
    "rmagatti/auto-session",

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config

    lazy = false,
    opts = (no_session == false) and {
        suppressed_dirs = { '~/Downloads' },
        auto_save = true,    -- Always save sessions
        auto_create = true,  -- Always create a new session for the current workspace
        auto_restore = true, -- Disable restoration if --new-session is passed
    } or {
        suppressed_dirs = { '~/Downloads' },
        enabled = false,
    },
}
