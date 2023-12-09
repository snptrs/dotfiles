return {
  -- Theme inspired by Atom
  'navarasu/onedark.nvim',
  opts = {
    style = 'darker',
    colors = {
      purple = '#B57EDC',
      red = '#E06C75',
      green = '#98C379',
      light_grey = '#A9B2C3',
      faded_grey = '#606671',
      yellow = '#E5C07B',
      orange = '#D19A66',
      blue = '#61AFEF',
      cyan = '#56B6C2',
    },
    highlights = {
      Include = { fg = '$red' },
      Keyword = { fg = '$red' },
      Define = { fg = '$red' },
      ['@include'] = { fg = '$red' },
      ['@tag.delimiter'] = { fg = '$faded_grey' },
      ['@punctuation.delimiter'] = { fg = '$faded_grey' },
      ['@punctuation.bracket'] = { fg = '$faded_grey' },
      ['@type'] = { fg = '$light_grey' },
    },
  },
  priority = 1000,
  config = function(_, opts)
    require('onedark').setup(opts)
    vim.cmd.colorscheme 'onedark'
  end,
}
