return {
  'MeanderingProgrammer/render-markdown.nvim',
  main = 'render-markdown',
  opts = { file_types = {
    'markdown',
    'Avante',
  } },
  ft = { 'markdown', 'Avante' },
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
}
