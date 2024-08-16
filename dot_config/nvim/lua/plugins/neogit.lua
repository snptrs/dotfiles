return {
  'NeogitOrg/neogit',
  branch = 'master',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration

    -- Only one of these is needed, not both.
    'nvim-telescope/telescope.nvim', -- optional
  },
  keys = {
    {
      '<leader>gg',
      '<cmd>Neogit<cr>',
      desc = 'Open Neo[g]it',
    },
  },
  config = true,
}
