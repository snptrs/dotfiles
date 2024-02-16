return {
  'kylechui/nvim-surround',
  version = '*', -- Use for stability; omit to use `main` branch for the latest features
  event = 'VeryLazy',
  opts = {
    keymaps = {
      insert = '<C-g>z',
      insert_line = '<C-g>Z',
      normal = 'gz',
      normal_cur = 'gZ',
      normal_line = 'gzz',
      normal_cur_line = 'gZZ',
      visual = 'gz',
      visual_line = 'gZ',
      delete = 'gzd',
      change = 'gzc',
    },
  },
}
