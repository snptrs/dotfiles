return {
  'sindrets/diffview.nvim',
  lazy = true,
  opts = {
    enhanced_diff_hl = true,
    view = {
      merge_tool = {
        layout = 'diff3_mixed',
      },
    },
  },
  keys = {
    { '<leader>gdo', '<cmd>DiffviewOpen<CR>', desc = 'Git Diffview Open' },
    { '<leader>gdc', ':DiffviewClose<CR>', desc = 'Git Diffview Close' },
    { '<leader>gdp', ':DiffviewOpen<CR>', desc = 'Git Diffview previous commit (HEAD~)' },
    { '<leader>gdh', ':DiffviewFileHistory %<CR>', desc = 'Git Diffview current file history' },
    { '<leader>gdH', ':DiffviewFileHistory<CR>', desc = 'Git Diffview cwd file history' },
    { '<leader>gdb', ':DiffviewOpen origin/main...HEAD', desc = 'Git Diffview against a commit' },
  },
}
