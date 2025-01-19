deps.later(function()
  deps.add {
    source = 'NeogitOrg/neogit',
    depends = { 'nvim-lua/plenary.nvim' },
  }
  require('neogit').setup {}

  vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { noremap = true, silent = true, desc = 'Open Neo[g]it' })
end)
