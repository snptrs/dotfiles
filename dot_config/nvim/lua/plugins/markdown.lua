return {
  'MeanderingProgrammer/markdown.nvim',
  main = 'render-markdown',
  event = 'BufEnter *.md',
  opts = {},
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
}
