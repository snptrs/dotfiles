local map = vim.keymap.set

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ SP's keymaps ]]
vim.keymap.set('n', '\\', function()
  if not MiniFiles.close() then
    MiniFiles.open()
  end
end, { desc = 'Tree focus' })

vim.keymap.set({ 'n', 'i' }, '<C-\\>', ':ToggleTerm size=10 direction=horizontal<CR>', {})
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], {})
map('n', 'x', '"xx', { desc = 'Delete single characters to the x register' })
map('n', 'c', '"cc', { desc = 'Yank change text to the c register' })
