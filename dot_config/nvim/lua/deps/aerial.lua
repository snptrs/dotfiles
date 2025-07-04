deps.now(function()
  deps.add {
    source = 'stevearc/aerial.nvim',
  }
  require('aerial').setup {
    on_attach = function(bufnr)
      vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
      vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
    end,
  }

  vim.keymap.set('n', '<leader>S', '<cmd>AerialToggle!<CR>')
end)
