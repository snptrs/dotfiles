return {
  'folke/trouble.nvim',
  opts = {
    modes = {
      lsp_document_symbols = {
        format = '{kind_icon} {symbol.name}',
      },
    },
    vim.api.nvim_create_autocmd('QuickFixCmdPost', {
      callback = function()
        vim.cmd [[Trouble qflist open]]
      end,
    }),
  },
  cmd = 'Trouble',
  keys = {
    { '<leader>tx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
    { '<leader>tX', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
    {
      '<leader>ts',
      '<cmd>Trouble lsp_document_symbols toggle win.position=right focus=false win.position=right focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    { '<leader>tl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
    { '<leader>tL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
    { '<leader>tq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
  },
}
