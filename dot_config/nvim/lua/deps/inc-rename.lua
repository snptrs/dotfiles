deps.later(function()
  deps.add {
    source = 'smjonas/inc-rename.nvim',
  }
  require('inc_rename').setup {}

  vim.keymap.set('n', '<leader>cr', ':IncRename ')
end)
