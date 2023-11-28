return {
  'sindrets/diffview.nvim',
  opts = {
    enhanced_diff_hl = true,
  },
  vim.keymap.set('n', '<leader>gdo', ':DiffviewOpen<CR>', { desc = 'Open [d]iff view' }),
  vim.keymap.set('n', '<leader>gdc', ':DiffviewClose<CR>', { desc = 'Close [d]iff view' }),
}
