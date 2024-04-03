return {
  'NeogitOrg/neogit',
  branch = 'nightly',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration

    -- Only one of these is needed, not both.
    'nvim-telescope/telescope.nvim', -- optional
  },
  vim.keymap.set('n', '<leader>gg', ':Neogit<CR>', { desc = 'Open Neo[g]it' }),

  config = true,
}
