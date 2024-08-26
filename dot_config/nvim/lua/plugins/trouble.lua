return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    modes = {
      lsp_document_symbols = {
        format = '{kind_icon} {symbol.name}',
      },
    },
  },
  cmd = 'Trouble',
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
    {
      '<leader>xs',
      '<cmd>Trouble lsp_document_symbols toggle filter={ any = { { kind = { "Function" } }, { kind = { "Method" } }, { kind = { "Class" } }, { kind = { "Constructor"} }, {kind = { "Interface" } } } } win.position=right focus=false win.position=right focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
    { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
    { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
  },
}
