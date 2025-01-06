return {
  'olimorris/codecompanion.nvim',
  enabled = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
      'stevearc/dressing.nvim', -- Optional: Improves the default Neovim UI
      opts = {},
    },
  },
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
    display = {
      action_palette = {
        width = 75,
        height = 10,
        prompt = "Prompt ",     -- Prompt used for interactive LLM calls
        provider = "mini_pick", -- default|telescope|mini_pick
      }
    }
  },
}
