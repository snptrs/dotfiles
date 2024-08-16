return {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  main = 'ibl',
  opts = {
    indent = { highlight = { 'CursorColumn', 'Whitespace' }, char = '' },
    scope = { enabled = false },
    whitespace = {
      highlight = { 'CursorColumn', 'Whitespace' },
      remove_blankline_trail = false,
    },
  },
}
