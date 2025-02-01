deps.later(function()
  deps.add {
    source = 'akinsho/git-conflict.nvim',
  }
  -- Some comment here
  ---@diagnostic disable-next-line: missing-fields
  require('git-conflict').setup {
    default_mappings = true,
    default_commands = true,
    disable_diagnostics = true,
    list_opener = 'copen',
    highlights = {
      incoming = 'DiffAdd',
      current = 'DiffText',
    },
  }

  vim.keymap.set('n', '<leader>gC', '<cmd>GitConflictListQf<CR>', { desc = 'List conflicts' })
end)
