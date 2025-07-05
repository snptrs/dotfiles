deps.later(function()
  deps.add {
    source = 'milanglacier/minuet-ai.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  }

  require('minuet').setup {
    provider = 'codestral',
    blink = {
      enable_auto_complete = true,
    },
    provider_options = {
      codestral = {
        optional = {
          max_tokens = 256,
          stop = { '\n\n' },
        },
      },
    },
  }
end)
