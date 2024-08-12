return {
  'sindrets/diffview.nvim',
  opts = {
    enhanced_diff_hl = true,
    view = {
      merge_tool = {
        layout = 'diff3_mixed',
      },
    },
  },
  vim.keymap.set('n', '<leader>gdo', ':DiffviewOpen<CR>', { desc = 'Git Diffview Open' }),
  vim.keymap.set('n', '<leader>gdc', ':DiffviewClose<CR>', { desc = 'Git Diffview Close' }),
  vim.keymap.set('n', '<leader>gdp', ':DiffviewOpen<CR>', { desc = 'Git Diffview previous commit (HEAD~)' }),
  vim.keymap.set('n', '<leader>gdh', ':DiffviewFileHistory %<CR>', { desc = 'Git Diffview current file history' }),
  vim.keymap.set('n', '<leader>gdH', ':DiffviewFileHistory<CR>', { desc = 'Git Diffview cwd file history' }),
  vim.keymap.set('n', '<leader>gdb', ':DiffviewOpen origin/main...HEAD', { desc = 'Git Diffview against a commit' }),
}
