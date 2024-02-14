return {
  'sindrets/diffview.nvim',
  opts = {
    enhanced_diff_hl = true,
  },
  vim.keymap.set('n', '<leader>gdo', ':DiffviewOpen<CR>', { desc = '[G]it [D]iffview [O]pen' }),
  vim.keymap.set('n', '<leader>gdc', ':DiffviewClose<CR>', { desc = '[G]it [D]iffview [C]lose' }),
}
