deps.later(function()
  deps.add {
    source = 'MeanderingProgrammer/render-markdown.nvim',
    depends = { 'nvim-treesitter/nvim-treesitter' },
  }
  require('render-markdown').setup {
    file_types = {
      'markdown',
    },
  }
end)
