deps.now(function()
  deps.add {
    source = 'folke/trouble.nvim',
  }
  require('trouble').setup {
    auto_preview = false,
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

  vim.keymap.set('n', '<leader>tx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics' })
  vim.keymap.set('n', '<leader>tX', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics' })
  vim.keymap.set(
    'n',
    '<leader>ts',
    '<cmd>Trouble lsp_document_symbols toggle win.position=right focus=false win.position=right focus=false<cr>',
    { desc = 'Symbols' }
  )
  vim.keymap.set('n', '<leader>tl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'LSP Definitions/references etc.' })
  vim.keymap.set('n', '<leader>tL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List' })
  vim.keymap.set('n', '<leader>tq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List' })
end)
