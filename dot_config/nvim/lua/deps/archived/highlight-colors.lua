deps.later(function()
  deps.add {
    source = 'brenoprata10/nvim-highlight-colors',
  }
  require('nvim-highlight-colors').setup {
    enable_named_colors = false,
    exclude_filetypes = { 'lazy', 'minideps-confirm' },
  }
end)
