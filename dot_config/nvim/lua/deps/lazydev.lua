deps.later(function()
  deps.add {
    source = 'folke/lazydev.nvim',
  }
  ---@diagnostic disable-next-line: missing-fields
  require('lazydev').setup {
    library = {
      '~/.local/share/nvim/site/pack/deps/opt/snacks.nvim',
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  }
end)
