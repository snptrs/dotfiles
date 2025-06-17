deps.later(function()
  deps.add {
    source = 'zbirenbaum/copilot.lua',
  }
  require('copilot').setup {
    auto_refresh = true,
    suggestion = {
      enabled = true,
      auto_trigger = false,
      keymap = {
        accept = '<C-j>',
        accept_word = '<M-Right>',
        accept_line = '<M-l>',
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
      },
    },
    panel = {
      enabled = false,
    },

    copilot_node_command = vim.fn.expand '$FNM_MULTISHELL_PATH' .. '/bin/node',
    -- copilot_node_command = '/Users/seanpeters/.local/share/fnm/aliases/default/bin/node',
  }
end)
