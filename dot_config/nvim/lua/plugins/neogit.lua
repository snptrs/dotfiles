return {
  'NeogitOrg/neogit',
  branch = 'master',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    -- "echasnovski/mini.pick"
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
