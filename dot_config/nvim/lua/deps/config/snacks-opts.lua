return {
  notifier = {
    opts = {
      enabled = false,
      timeout = 3000,
      style = 'compact',
    },
  },

  picker = {
    opts = {
      actions = require('trouble.sources.snacks').actions,
      win = {
        input = {
          keys = {
            ['<c-t>'] = {
              'trouble_open',
              mode = { 'n', 'i' },
            },
            ['<m-t>'] = {
              'trouble_add',
              mode = { 'n', 'i' },
            },
          },
        },
      },
      formatters = {
        file = {
          filename_first = true,
        },
      },
    },
  },

  styles = {
    opts = {
      notification = {
        relative = 'editor',
        wo = { wrap = true }, -- Wrap notifications
      },
      zen = {
        relative = 'editor',
        backdrop = {
          transparent = false,
        },
      },
    },
  },

  zen = {
    opts = {
      enabled = true,
      toggles = {
        dim = false,
        diagnostics = false,
      },
    },
  },
}
