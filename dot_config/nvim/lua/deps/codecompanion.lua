deps.later(function()
  deps.add {
    source = 'olimorris/codecompanion.nvim',
    depends = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  }

  require('codecompanion').setup {
    adapters = {
      anthropic = function()
        return require('codecompanion.adapters').extend('anthropic', {
          env = {
            api_key = 'cmd:cat ~/.config/anthropic-api.txt',
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
  }

  vim.cmd [[cab cc CodeCompanion]]

  vim.keymap.set({ 'n', 'v' }, '<leader>cca', '<cmd>CodeCompanionActions<cr>', { desc = 'CodeCompanion Actions' })
  vim.keymap.set({ 'n', 'v' }, '<leader>ccc', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'CodeCompanion Chat' })
end)
