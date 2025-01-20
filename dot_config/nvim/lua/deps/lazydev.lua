deps.later(function()
  deps.add {
    source = 'folke/lazydev.nvim',
  }
  ---@diagnostic disable-next-line: missing-fields
  require('lazydev').setup {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      { path = 'snacks.nvim', words = { 'Snacks' } },
      { path = 'mini.nvim', words = { 'MiniStatusline' } },
    },
  }
end)
