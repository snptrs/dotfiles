return {
  'zbirenbaum/copilot.lua',
  event = 'InsertEnter',
  enabled = true,
  config = function()
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
      copilot_node_command = '/System/Volumes/Data/Users/seanpeters/Library/Application Support/fnm/aliases/20/bin/node',
    }
  end,
  -- dependencies = {
  --   'zbirenbaum/copilot-cmp',
  --   config = function()
  --     require('copilot_cmp').setup()
  --   end,
  -- },
}
