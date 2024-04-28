local map = vim.keymap.set

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true, unique = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, unique = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, unique = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message', unique = true })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message', unique = true })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message', unique = true })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list', unique = true })

-- [[ SP's keymaps ]]
vim.keymap.set('n', '<leader>\\', function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
    MiniFiles.reveal_cwd()
  end
end, { desc = 'Tree focus', unique = true })

-- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], {})
map('n', 'x', '"xx', { desc = 'Delete single characters to the x register', unique = true })
map('n', 'c', '"cc', { desc = 'Yank change text to the c register', unique = true })

-- map({ 'n', 'i' }, '<C-M-l>', ':nohl<cr>', { desc = 'Search highlighting off', silent = true, unique = true })
-- map('n', '*', '*``b', { desc = 'Search for word under cursor without jumping to next occurrence', unique = true })

map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down', unique = true })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up', unique = true })

map({ 'n', 'v' }, 'H', '^', { desc = 'Move to beginning of line', unique = true })
map({ 'n', 'v' }, 'L', '$', { desc = 'Move to end of line', unique = true })

-- Split Navigation
map('n', '<Left>', '<C-w>h', { desc = 'Switch to the left split', unique = true })
map('n', '<Right>', '<C-w>l', { desc = 'Switch to the right split', unique = true })
map('n', '<Down>', '<C-w>j', { desc = 'Switch to the bottom split', unique = true })
map('n', '<Up>', '<C-w>k', { desc = 'Switch to the top split', unique = true })

-- Disable arrow keys in insert mode
-- vim.keymap.set({ 'i' }, '<Left>', '<Nop>', { silent = true })
-- vim.keymap.set({ 'i' }, '<Right>', '<Nop>', { silent = true })
-- vim.keymap.set({ 'i' }, '<Up>', '<Nop>', { silent = true })
-- vim.keymap.set({ 'i' }, '<Down>', '<Nop>', { silent = true })
