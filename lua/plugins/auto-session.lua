return {
    "rmagatti/auto-session",

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config

    lazy = false,
    opts = {
        suppressed_dirs = { '~/Downloads' },
        auto_save = true,
        auto_restore = true,
        auto_create = true,
    },
}
