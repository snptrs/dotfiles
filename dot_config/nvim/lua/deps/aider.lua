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
      tool_output_color = '#8aadf4',
      tool_error_color = '#d8647e',
      tool_warning_color = '#eed49f',
      assistant_output_color = '#cad3f5',
      completion_menu_color = '#cad3f5',
      completion_menu_bg_color = '#aeaed1',
      completion_menu_current_color = '#181926',
      completion_menu_current_bg_color = '#f4dbd6',
    },
  }
end)
