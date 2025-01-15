return {
  'folke/lazydev.nvim',
  ft = 'lua', -- only load on lua files
  opts = {
    library = {
      '~/.local/share/nvim/lazy/snacks.nvim',
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}
