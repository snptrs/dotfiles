deps.later(function()
  deps.add {
    source = 'GeorgesAlkhouri/nvim-aider',
    depends = { 'folke/snacks.nvim' },
  }

  require('nvim_aider').setup {
    args = {
      '--no-auto-commits',
      '--pretty',
      '--stream',
      '--watch-files',
    },
    auto_reload = true,
    theme = {
      user_input_color = '#7fa563',
      tool_output_color = '#b4d4cf',
      tool_error_color = '#d8647e',
      tool_warning_color = '#eed49f',
      assistant_output_color = '#aeaed1',
      completion_menu_color = '#cad3f5',
      completion_menu_bg_color = '#252530',
      completion_menu_current_color = '#181926',
      completion_menu_current_bg_color = '#f4dbd6',
    },
    -- snacks.picker.layout.Config configuration
    picker_cfg = {
      preset = 'select',
    },
  }

  vim.keymap.set('n', '<leader>a/', '<cmd>Aider toggle<cr>', { desc = 'Toggle Aider' })
  vim.keymap.set({ 'n', 'v' }, '<leader>as', '<cmd>Aider send<cr>', { desc = 'Send to Aider' })
  vim.keymap.set('n', '<leader>ac', '<cmd>Aider command<cr>', { desc = 'Aider Commands' })
  vim.keymap.set('n', '<leader>ab', '<cmd>Aider buffer<cr>', { desc = 'Send Buffer' })
  vim.keymap.set('n', '<leader>a+', '<cmd>Aider add<cr>', { desc = 'Add File' })
  vim.keymap.set('n', '<leader>a-', '<cmd>Aider drop<cr>', { desc = 'Drop File' })
  vim.keymap.set('n', '<leader>ar', '<cmd>Aider add readonly<cr>', { desc = 'Add Read-Only' })
  vim.keymap.set('n', '<leader>aR', '<cmd>Aider reset<cr>', { desc = 'Reset Session' })
end)
