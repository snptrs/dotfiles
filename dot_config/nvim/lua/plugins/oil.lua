return {
  'stevearc/oil.nvim',
  enabled = true,
  opts = {
    skip_confirm_for_simple_edits = true,
    constrain_cursor = 'name',
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' }),
  },
  -- Optional dependencies
  -- dependencies = { 'nvim-tree/nvim-web-devicons' },
  dependencies = {
    'echasnovski/mini.nvim',
  },
}
