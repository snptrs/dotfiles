deps.later(function()
  deps.add {
    source = 'cbochs/grapple.nvim',
  }
  require('grapple').setup {
    scope = 'git',
    icons = true,
    name_pos = 'end',
    style = 'relative',
    quick_select = '1234567890',
  }

  vim.keymap.set('n', '<leader>,', '<cmd>Grapple toggle_tags<cr>', { desc = 'Toggle tags menu' })
  vim.keymap.set('n', '<leader>m', '<cmd>Grapple toggle<cr>', { desc = 'Toggle tag' })
  vim.keymap.set('n', '<leader>]', '<cmd>Grapple cycle_tags next<cr>', { desc = 'Go to next tag' })
  vim.keymap.set('n', '<leader>[', '<cmd>Grapple cycle_tags prev<cr>', { desc = 'Go to previous tag' })
end)
