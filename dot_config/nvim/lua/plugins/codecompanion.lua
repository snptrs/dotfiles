return {
  'olimorris/codecompanion.nvim',
  enabled = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    { '<Leader>cca', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion Actions' },
    { '<Leader>ccc', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'Toggle CodeCompanion Chat' },
    { '<Leader>ccd', '<cmd>CodeCompanionChat Add<cr>', mode = 'v', desc = 'Add to CodeCompanion Chat' },
    {
      '<Leader>ccm',
      function()
        require('codecompanion').prompt 'commit'
      end,
      mode = 'n',
      desc = 'Add to CodeCompanion Chat',
    },
  },
  init = function()
    vim.cmd [[cab cc CodeCompanion]]
  end,
  opts = {
    adapters = {
      anthropic = function()
        return require('codecompanion.adapters').extend('anthropic', {
          env = {
            api_key = 'cmd:cat ~/.config/anthropic-api.txt',
          },
          schema = {
            model = {
              default = 'claude-3-5-sonnet-20241022',
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = 'anthropic',
      },
      inline = {
        adapter = 'anthropic',
      },
      agent = {
        adapter = 'anthropic',
      },
    },
    opts = {
      log_level = 'ERROR', -- TRACE|DEBUG|ERROR|INFO

      -- If this is false then any default prompt that is marked as containing code
      -- will not be sent to the LLM. Please note that whilst I have made every
      -- effort to ensure no code leakage, using this is at your own risk
      send_code = true,

      use_default_actions = true, -- Show the default actions in the action palette?
      use_default_prompts = true, -- Show the default prompts in the action palette?
    },
  },
}
