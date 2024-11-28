return {
  'MeanderingProgrammer/render-markdown.nvim',
  main = 'render-markdown',
  opts = { file_types = {
    'markdown',
    'Avante',
    'codecompanion',
  } },
  ft = { 'markdown', 'Avante', 'codecompanion' },
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
}
