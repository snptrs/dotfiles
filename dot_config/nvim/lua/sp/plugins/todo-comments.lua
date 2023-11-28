return {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    vim.keymap.set('n', '<leader>ft', ':TodoTelescope<cr>', { desc = 'Search [t]odos' }),
    vim.keymap.set('n', '<leader>xt', ':TodoTrouble<cr>', { desc = 'Show [t]odos in Trouble' }),
  },
}
