deps.later(function()
  deps.add {
    source = 'milanglacier/minuet-ai.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  }

  require('minuet').setup {
    provider = 'gemini',
    blink = {
      enable_auto_complete = true,
    },
  }
end)
