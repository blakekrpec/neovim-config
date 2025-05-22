vim.g.mapleader = " "

local builtin = require('telescope.builtin')

local function map(mode, lhs, rhs, opts)
    opts = opts or {}  -- Ensure opts is a table
    opts.silent = true -- Always set silent to true
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- detect the operating system
local is_windows = vim.loop.os_uname().version:match("Windows")

-- ---- General Vim Stuff
-- clear highlights
map("n", "<Leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
-- decrement number
map("n", "<Leader>-", "<C-x>", { desc = "Decrement number" })
-- exit insert mode
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })
-- increment number
map("n", "<Leader>+", "<C-a>", { desc = "Increment number" })
-- last buffer
map("n", "<Leader>lb", "<CMD>b#<CR>", { desc = "Switch to last buffer" })
-- quit
map("n", "<leader>q", "<CMD>q<CR>", { desc = "Quit current window" })
-- save
map("n", "<leader>w", "<CMD>update<CR>", { desc = "Save current buffer" })

-- ---- Comments
map("n", "<leader>/", ":lua require('Comment.api').toggle.linewise.current()<CR>", { desc = "Toggle comments"})
map("v", "<leader>/", ":lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comments"})

-- ---- Debug
-- start debugger and dap ui
map("n", "<leader>db", function()
    require("dapui").toggle()
    require("dap").continue()
end, { desc = "Toggle DAP UI and start debugging" })
-- dap continue
map("n", "<leader>dc", "<CMD>:DapContinue<CR>", { desc = "Continue debugging (DAP)" })
-- disconnect debugger and close dap ui
map("n", "<leader>dt", function()
    require("dapui").toggle()
    require("dap").terminate()
    require("dap").disconnect()
end, { desc = "Toggle DAP UI and stop debugging" })
-- toggle dap breakpoint
map("n", "<leader>dg", "<CMD>:DapToggleBreakpoint<CR>", { desc = "Toggle DAP breakpoint."})
-- dap hover
map("n", "<leader>dh", function()
    require("dapui").eval(nil, {
        enter = true,
        context = "hover", -- could also be "scopes" or others
        height = 10,
        width = 50,
    })
end, { desc = "DAP Hover Eval (Float)" })

-- ---- Lazy
map("n", "<leader>ls", ":Lazy sync<CR>", { desc = "Sync Lazy.nvim plugins" })

-- ---- LSP, Trouble
-- see code action
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap=true, silent=true, desc = "LSP Code Action" })
-- go-to-declaration
map("n", "<leader>gD", '<cmd>lua vim.lsp.buf.declaration()<CR>', { desc = "Go to declaration" })
-- go-to-definition
map("n", "<leader>gd", '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = "Go to definition" })
-- hover
map("n", "<leader>K", '<cmd>lua vim.lsp.buf.hover()<CR>', { desc = "Hover information" })
-- rename symbol
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })
-- show references with Trouble
map("n", "<leader>gr", function()
  require("trouble").open("lsp_references")
end, { desc = "Get references - Trouble" })
-- show document diagnostics with Trouble
map("n", "<leader>td", function()
  require("trouble").open({
        mode = "diagnostics",
        filter = { buf = 0 },
    })
end, { desc = "Get document diagnostics - Trouble" })
-- show workspace diagnostics with Trouble
map("n", "<leader>tw", function()
  require("trouble").open({
        mode = "diagnostics",
    })
end, { desc = "Get workspace diagnostics - Trouble" })
-- switch between cpp and header
map("n", "<F4>", ':ClangdSwitchSourceHeader<CR>', { desc = "Switch between source/header (C++)" })

-- ---- NeoTree
map("n", "<leader>nf", "<CMD>Neotree toggle filesystem<CR>", { desc = "Toggle NeoTree filesystem" })
map("n", "<leader>nb", "<CMD>Neotree toggle buffers<CR>", { desc = "Toggle NeoTree buffers" })

-- ---- Outline
map("n", "<leader>o", "<CMD>Outline<CR>", { desc = "Toggle symbols outline" })

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
        }
    )
end, { desc = "Fuzzy find Neovim config files" })

-- ---- ToggleTerm
map("n", "<leader>ty", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
