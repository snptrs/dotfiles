return {
  'stevearc/oil.nvim',
  enabled = true,
  opts = {
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' }),
  },
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
