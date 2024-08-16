return {
  'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
  main = 'rainbow-delimiters.setup',
  event = 'VeryLazy',
  opts = {
    highlight = {
      'RainbowDelimiterYellow',
      'RainbowDelimiterBlue',
      'RainbowDelimiterOrange',
      'RainbowDelimiterGreen',
      'RainbowDelimiterViolet',
      'RainbowDelimiterCyan',
    },
    query = {
      [''] = 'rainbow-delimiters',
    },
  },
}
