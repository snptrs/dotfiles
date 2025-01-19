deps.later(function()
  deps.add {
    source = 'folke/trouble.nvim',
  }
  require('trouble').setup {
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
  }

  vim.keymap.set('n', '<leader>tx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
  vim.keymap.set('n', '<leader>tX', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
  vim.keymap.set(
    'n',
    '<leader>ts',
    '<cmd>Trouble lsp_document_symbols toggle win.position=right focus=false win.position=right focus=false<cr>',
    { desc = 'Symbols (Trouble)' }
  )
  vim.keymap.set('n', '<leader>tl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'LSP Definitions / references / ... (Trouble)' })
  vim.keymap.set('n', '<leader>tL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
  vim.keymap.set('n', '<leader>tq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })
end)
