deps.now(function()
  deps.add {
    source = 'thesimonho/kanagawa-paper.nvim',
  }

  require('kanagawa-paper').setup {
    -- enable undercurls for underlined text
    undercurl = true,
    -- transparent background
    transparent = false,
    -- highlight background for the left gutter
    gutter = false,
    -- background for diagnostic virtual text
    diag_background = true,
    -- dim inactive windows. Disabled when transparent
    dim_inactive = true,
    -- set colors for terminal buffers
    terminal_colors = true,
    -- cache highlights and colors for faster startup.
    -- see Cache section for more details.
    cache = true,

    -- adjust overall color balance for each theme [-1, 1]
    color_offset = {
      ink = { brightness = -1, saturation = 1 },
      canvas = { brightness = 0, saturation = 0 },
    },
  }

  vim.cmd.colorscheme 'kanagawa-paper'
end)
