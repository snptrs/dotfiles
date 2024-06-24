return {
  'zeioth/garbage-day.nvim',
  enabled = false,
  dependencies = 'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  opts = {
    excluded_lsp_clients = { 'typescript-tools' },
  },
}
