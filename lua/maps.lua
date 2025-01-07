vim.g.mapleader = " "

local function map(mode, lhs, rhs, opts)
    opts = opts or {}  -- Ensure opts is a table
    opts.silent = true -- Always set silent to true
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- detect the operating system
local is_windows = vim.loop.os_uname().version:match("Windows")

-- ---- General Vim Stuff
-- clear highlights
map("n", "<Leader>nh", ":nohl<CR>")
-- decrement number
map("n", "<Leader>-", "<C-x>")
-- exit insert mode
map("i", "jj", "<ESC>")
-- increment number
map("n", "<Leader>+", "<C-a>")
-- last buffer
map("n", "<Leader>lb", "<CMD>b#<CR>")
-- quit
map("n", "<leader>q", "<CMD>q<CR>")
-- save
map("n", "<leader>w", "<CMD>update<CR>")

-- ---- Comments
map("n", "<leader>/", ":lua require('Comment.api').toggle.linewise.current()<CR>")
map("v", "<leader>/", ":lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

-- ---- Debug

-- ---- Lazy
map("n", "<leader>ls", ":Lazy sync<CR>")

-- ---- LSP
-- go-to-declaration
map("n", "<leader>gD", '<cmd>lua vim.lsp.buf.declaration()<CR>')
-- go-to-definition
map("n", "<leader>gd", '<cmd>lua vim.lsp.buf.definition()<CR>')
-- hover
map("n", "<leader>K", '<cmd>lua vim.lsp.buf.hover()<CR>')
-- rename symbol
map("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>")
-- show refs
map("n", "<leader>gr", '<cmd>lua vim.lsp.buf.references()<CR>', { desc = "Get references - Vim/LSP" })
-- switch between cpp and header
map("n", "<F4>", ':ClangdSwitchSourceHeader<CR>')

-- ---- NeoTree
map("n", "<leader>nf", "<CMD>Neotree toggle filesystem<CR>")
map("n", "<leader>nb", "<CMD>Neotree toggle buffers<CR>")

-- ---- Outline
map("n", "<leader>o", "<CMD>Outline<CR>")

-- ---- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Fuzzy find recent files" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find string in cwd" })
map("n", "<leader>fs", "<cmd>Telescope git_status<cr>", { desc = "Find string under cursor in cwd" })
map("n", "<leader>fc", "<cmd>Telescope git commits<cr>", { desc = "Find todos" })
map("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", { desc = "Get references - Telescope" })
-- keybinding to access the .config/nvim directory
map("n", "<leader>cn", function()
    local home = vim.loop.os_homedir()
    local nvim_config_path = is_windows and
        (home .. "\\AppData\\Local\\nvim") or
        (home .. "/.config/nvim")

    builtin.find_files(
        {
            prompt_title = "< NVim Config >",
            cwd = nvim_config_path, -- Set cwd based on platform
            hidden = false,         -- Exclude hidden files
        })
end, { desc = "Fuzzy find Neovim config files" })

-- ---- ToggleTerm
map("n", "<leader>ty", "<cmd>ToggleTerm<CR>")
