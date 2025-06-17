deps.now(function()
  deps.add {
    source = 'https://github.com/vague2k/vague.nvim',
    name = 'vague',
  }

  require('vague').setup {
    italic = true,
    on_highlights = function(highlights, colors)
      highlights.LspReferenceText = { gui = 'underline' }
      highlights.LspReferenceRead = { gui = 'underline' }
      highlights.LspReferenceWrite = { gui = 'underline' }
      highlights.MiniIndentscopeSymbol = { fg = colors.error, bg = colors.error }
      highlights.SnacksIndent = { fg = colors.line }
      highlights.SnacksIndentScope = { fg = colors.fg }

      -- Formatting for Markdown
      highlights.RenderMarkdownBullet = { fg = colors.keyword }
      highlights.RenderMarkdownTableRow = { fg = colors.keyword }
      highlights.RenderMarkdownCode = { bg = colors.line }

      highlights['@markup.strong'] = { fg = colors.keyword, gui = 'bold' }
      highlights['@markup.italic'] = { fg = colors.keyword, gui = 'italic' }
      highlights['@markup.heading.1'] = { fg = colors.constant, gui = 'bold' }
      highlights['@markup.heading.2'] = { fg = colors.parameter, gui = 'bold' }
      highlights['@markup.heading.3'] = { fg = colors.type, gui = 'bold' }
      highlights['@markup.heading.4'] = { fg = colors.operator, gui = 'bold' }
      highlights['@markup.heading.5'] = { fg = colors.plus, gui = 'bold' }
      highlights['@markup.heading.6'] = { fg = colors.func, gui = 'bold' }

      local groups = {}
      for i = 1, 6 do
        groups['h' .. i] = highlights['@markup.heading.' .. i]
      end
      local cs = require('mini.colors').as_colorscheme { groups = groups }
      cs = cs:chan_invert('lightness', { gamut_clip = 'cusp' })
      cs = cs:chan_add('lightness', -5)
      for i = 1, 6 do
        local bg = cs.groups['h' .. i].fg
        highlights['RenderMarkdownH' .. i .. 'Bg'] = { bg = bg }
      end
      -- End formatting for Markdown
    end,
    style = {
      -- "none" is the same thing as default. But "italic" and "bold" are also valid options
      strings = 'none',
    },
  }

  vim.cmd.colorscheme 'vague'
end)
