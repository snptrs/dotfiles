return {
  notifier = {
    enabled = true,
    timeout = 3000,
  },

  picker = {
    win = {
      input = {
        keys = {
          ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
          ['<C-/>'] = { 'toggle_help', mode = { 'i', 'n' } },
        },
      },
    },
  },

  pickers = {
    files = {
      finder = 'files',
      format = 'file',
      hidden = true,
      ignored = false,
      follow = false,
      supports_live = true,
      layout = {
        preview = false,
        layout = {
          box = 'horizontal',
          width = 0.6,
          min_width = 120,
          height = 0.6,
          {
            box = 'vertical',
            border = 'rounded',
            title = '{source} {live}',
            title_pos = 'center',
            { win = 'input', height = 1, border = 'bottom' },
            { win = 'list', border = 'none' },
          },
          { win = 'preview', border = 'rounded', width = 0.5 },
        },
      },
    },

    buffers = {
      finder = 'buffers',
      format = 'buffer',
      hidden = false,
      unloaded = true,
      current = true,
      sort_lastused = true,
      layout = {
        preset = 'select',
      },
    },
  },

  styles = {
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

  zen = {
    enabled = true,
    toggles = {
      dim = false,
      diagnostics = false,
    },
  },
}
