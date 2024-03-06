return {
  'stevearc/oil.nvim',
  enabled = true,
  opts = {
    skip_confirm_for_simple_edits = true,
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' }),
  },
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
