deps.later(function()
  deps.add {
    source = 'otavioschwanck/arrow.nvim',
  }
  require('arrow').setup {
    show_icons = true,
    leader_key = '\\', -- Recommended to be a single key
    buffer_leader_key = '<Leader>m', -- Per Buffer Mappings
  }
end)
