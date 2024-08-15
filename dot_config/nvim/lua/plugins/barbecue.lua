return {
  'utilyre/barbecue.nvim',
  enabled = false,
  name = 'barbecue',
  version = '*',
  dependencies = {
    'SmiteshP/nvim-navic',
    'nvim-tree/nvim-web-devicons', -- optional dependency
  },
  opts = {
    show_dirname = false,
    show_modified = true,
  },
}
