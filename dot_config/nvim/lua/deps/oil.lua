deps.later(function()
  deps.add {
    source = 'stevearc/oil.nvim',
  }

  require('oil').setup {
    skip_confirm_for_simple_edits = true,
    constrain_cursor = 'name',
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
    vim.keymap.set('n', '<Leader>\\', '<CMD>Oil<CR>', { desc = 'Open parent directory' }),
  }
end)
