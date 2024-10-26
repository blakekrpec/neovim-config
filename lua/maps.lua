vim.g.mapleader = " "

local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- ---- Genearl Vim Stuff
-- clear highlights
map("n", "<Leader>nh", ":nohl<CR>")
-- decrement number
map("n", "<Leader>-", "<C-x>")
-- exit insert mode
map("i", "jj", "<ESC>")
-- increment number
map("n", "<Leader>+", "<C-a>")
-- save
map("n", "<leader>w", "<CMD>update<CR>")
-- quit
map("n", "<leader>q", "<CMD>q<CR>")

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
map("n", "<leader>gr", '<cmd>lua vim.lsp.buf.references()<CR>')
-- switch between cpp and header
map("n", "<F4>", ':ClangdSwitchSourceHeader<CR>')

-- ---- NeoTree
map("n", "<leader>e", "<CMD>Neotree toggle<CR>")
map("n", "<leader>r", "<CMD>Neotree focus<CR>")

-- ---- Outline
map("n", "<leader>o", "<CMD>Outline<CR>")

-- ---- ToggleTerm
map("n", "<leader>t", "<cmd>ToggleTerm<CR>")
