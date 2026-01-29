local map = vim.keymap.set

-- Normal 모드 매핑
map('n', '<C-s>', ':w<CR>')
map('n', '<C-n>', ':NvimTreeToggle<CR>')

-- Insert 모드 매핑
map('i', '<C-s>', '<Esc>:w<CR>')
map('i', '<C-n>', '<Esc>:NvimTreeToggle<CR>')

-- Telescope 매핑
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
map('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<cr>')
map('n', '<leader>fS', '<cmd>Telescope lsp_workspace_symbols<cr>')

-- LSP 매핑
map('n', 'g[', vim.diagnostic.goto_prev)
map('n', 'g]', vim.diagnostic.goto_next)

-- Bufferline 매핑
map('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>')
map('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>')
map('n', '<leader>1', '<cmd>BufferLineGoToBuffer 1<cr>')
map('n', '<leader>2', '<cmd>BufferLineGoToBuffer 2<cr>')
map('n', '<leader>3', '<cmd>BufferLineGoToBuffer 3<cr>')
map('n', '<leader>4', '<cmd>BufferLineGoToBuffer 4<cr>')
map('n', '<leader>5', '<cmd>BufferLineGoToBuffer 5<cr>')
map('n', '<leader>bd', '<cmd>bdelete<cr>')
