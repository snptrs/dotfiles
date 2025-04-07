deps.later(function()
  deps.add {
    source = 'Saghen/blink.cmp',
    depends = { 'rafamadriz/friendly-snippets' },
    checkout = 'v1.0.0',
    monitor = 'main',
  }

  require('blink.cmp').setup {

    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = { preset = 'default' },

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
      default = { 'lsp', 'path', 'snippets', 'buffer', 'codecompanion' },
      -- optionally disable cmdline completion
      providers = {
        codecompanion = {
          name = 'CodeCompanion',
          module = 'codecompanion.providers.completion.blink',
        },
        cmdline = { enabled = true },
      },
    },

    completion = {
      documentation = {
        auto_show = true,
        window = {
          border = 'rounded',
        },
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
      window = { border = 'rounded' },
    },
  }
end)
