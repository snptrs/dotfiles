return {
  'stevearc/aerial.nvim',
  opts = {
    layout = {
      default_direction = 'right',
    },
    autojump = true,
  },
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>l', '<cmd>AerialToggle!<CR>', desc = 'Aerial toggle' },
  },
}
