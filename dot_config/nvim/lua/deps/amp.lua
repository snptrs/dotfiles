deps.later(function()
  deps.add {
    source = 'sourcegraph/amp.nvim',
  }
  require('amp').setup { auto_start = true, log_level = 'info' }
end)
