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
            api_key = 'ANTHROPIC_API_KEY',
          },
        })
      end,
      openai = function()
        return require('codecompanion.adapters').extend('openai', {
          env = {
            api_key = 'OPENAI_API_KEY',
          },
        })
      end,
      gemini = function()
        return require('codecompanion.adapters').extend('gemini', {
          env = {
            api_key = 'GEMINI_API_KEY',
          },
          schema = {
            model = {
              default = 'gemini-2.5-pro-preview-06-05',
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = 'gemini',
        slash_commands = {
          ['buffer'] = {
            opts = {
              provider = 'snacks',
            },
          },
          ['fetch'] = {
            opts = {
              provider = 'snacks',
            },
          },
          ['file'] = {
            opts = {
              provider = 'snacks',
            },
          },
          ['help'] = {
            opts = {
              provider = 'snacks',
            },
          },
          ['image'] = {
            opts = {
              provider = 'snacks',
            },
          },
          ['symbols'] = {
            opts = {
              provider = 'snacks',
            },
          },
        },
      },
      inline = {
        adapter = 'copilot',
      },
      cmd = {
        adapter = 'openai',
      },
    },
    opts = {
      log_level = 'ERROR', -- TRACE|DEBUG|ERROR|INFO
    },
    display = {
      action_palette = {
        provider = 'snacks', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
      },
    },
  }

  vim.cmd [[cab cc CodeCompanion]]

  vim.keymap.set({ 'n', 'v' }, '<leader>cca', '<cmd>CodeCompanionActions<cr>', { desc = 'CodeCompanion Actions' })
  vim.keymap.set({ 'n', 'v' }, '<leader>ccc', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'CodeCompanion Chat' })
end)
