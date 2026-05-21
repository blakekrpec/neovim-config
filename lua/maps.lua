vim.g.mapleader = " "

local builtin = require('telescope.builtin')

local function map(mode, lhs, rhs, opts)
    opts = opts or {}  -- Ensure opts is a table
    opts.silent = true -- Always set silent to true
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- detect the operating system
local is_windows = vim.uv.os_uname().version:match("Windows")

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
map("n", "<leader>ka", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap=true, silent=true, desc = "LSP Code Action" })
-- go-to-declaration
map("n", "<leader>kD", function()
  require("trouble").open("lsp_declarations")
end, { desc = "Go to declaration - Trouble" })
-- go-to-definition
map("n", "<leader>kd", function()
  require("trouble").open("lsp_definitions")
end, { desc = "Go to definition - Trouble" })
-- hover
map("n", "<leader>K", '<cmd>lua vim.lsp.buf.hover()<CR>', { desc = "Hover information" })
-- rename symbol
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })
-- show references with Trouble
map("n", "<leader>kr", function()
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
    local home = vim.uv.os_homedir()
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

-- ---- Git (gitsigns + diffview)
-- hunk navigation
map("n", "<leader>gj", function() require("gitsigns").nav_hunk("next") end, { desc = "Next git hunk" })
map("n", "<leader>gk", function() require("gitsigns").nav_hunk("prev") end, { desc = "Prev git hunk" })
-- stage / unstage / reset
map("n", "<leader>gs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
map("v", "<leader>gs", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage selected hunks" })
map("n", "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Undo stage hunk" })
map("n", "<leader>gR", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
-- inline preview & blame
map("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview hunk" })
map("n", "<leader>gb", function() require("gitsigns").toggle_current_line_blame() end, { desc = "Toggle line blame" })
-- diffview: open/close source-control panel
map("n", "<leader>gv", "<cmd>DiffviewOpen<CR>", { desc = "Open Diffview (changed files)" })
map("n", "<leader>gx", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
-- diffview: history
map("n", "<leader>gl", "<cmd>DiffviewFileHistory %<CR>", { desc = "File git history" })
map("n", "<leader>gL", "<cmd>DiffviewFileHistory<CR>", { desc = "Repo git history" })

-- ---- Copilot Chat
map("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Toggle Copilot Chat" })
map("v", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain selection" })
map("v", "<leader>cr", "<cmd>CopilotChatReview<cr>", { desc = "Review selection" })
map("v", "<leader>cf", "<cmd>CopilotChatFix<cr>", { desc = "Fix selection" })
map("v", "<leader>co", "<cmd>CopilotChatOptimize<cr>", { desc = "Optimize selection" })

-- ---- Render Markdown
map("n", "<leader>rm", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle markdown rendering" })

-- ---- ToggleTerm
map("n", "<leader>ty", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

-- ---- Terminal
map("t", "jj", "<C-\\><C-n>", { desc = "Exit terminal mode to normal" })

-- ---- Claude Code (coder/claudecode.nvim — VSCode-style IDE integration)
-- Toggle the Claude terminal on the right side.
map("n", "<leader>ac", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code" })
-- Focus/jump to Claude without toggling it off if it's already visible.
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<CR>", { desc = "Focus Claude Code" })
-- Send the current visual selection to Claude as an @-mention block.
map("v", "<leader>as", "<cmd>ClaudeCodeSend<CR>", { desc = "Send selection to Claude" })
-- Add the current buffer to Claude's context (normal mode, no selection).
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<CR>", { desc = "Add current buffer to Claude" })
-- Accept / deny the diff Claude is proposing in the review split.
map("n", "<leader>ay", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.b[buf].claudecode_diff_tab_name then
            vim.api.nvim_set_current_win(win)
            vim.cmd("ClaudeCodeDiffAccept")
            vim.schedule(function() pcall(vim.cmd, "ClaudeCodeFocus") end)
            return
        end
    end
    vim.notify("No active Claude diff found", vim.log.levels.WARN)
end, { desc = "Accept Claude diff" })
map("n", "<leader>an", "<cmd>ClaudeCodeDiffDeny<CR>",   { desc = "Deny Claude diff" })

-- ---- OpenCode (work AI via AWS Bedrock/Ollama — installed by Ansible playbook)
map("n", "<leader>ao", function() require("opencode").toggle() end, { desc = "Toggle OpenCode" })
