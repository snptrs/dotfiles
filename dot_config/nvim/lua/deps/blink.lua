deps.now(function()
  deps.add {
    source = 'Saghen/blink.cmp',
    depends = { 'rafamadriz/friendly-snippets', 'milanglacier/minuet-ai.nvim' },
    checkout = 'v1.7.0',
    monitor = 'main',
  }

  require('blink.cmp').setup {

    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = {
      preset = 'default',
      ['<M-Space>'] = require('minuet').make_blink_map(),
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },
    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      default = {
        'lsp',
        'path',
        'snippets',
        'buffer',
        -- 'minuet',
      },
      -- optionally disable cmdline completion
      providers = {
        minuet = {
          name = 'minuet',
          module = 'minuet.blink',
          async = true,
          -- Should match minuet.config.request_timeout * 1000,
          -- since minuet.config.request_timeout is in seconds
          timeout_ms = 3000,
          score_offset = 50, -- Gives minuet higher priority among suggestions
        },
        cmdline = { enabled = true },
      },
    },

    completion = {
      trigger = { prefetch_on_insert = false },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
      },
      menu = {
        draw = {
          columns = {
            {
              'kind_icon',
            },
            {
              'label',
              'label_description',
              gap = 1,
            },
            {
              'kind',
            },
          },
        },
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      ghost_text = {
        enabled = false,
      },
    },
    -- experimental signature help support
    signature = {
      enabled = true,
    },
  }
end)
