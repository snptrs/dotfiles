deps.now(function()
  deps.add {
    source = 'https://github.com/vague2k/vague.nvim',
    name = 'vague',
  }

  require('vague').setup {
    italic = true,
    style = {
      -- "none" is the same thing as default. But "italic" and "bold" are also valid options
      strings = 'none',
    },
    on_highlights = function(highlights, colors)
      local utilities = require 'vague.utilities'
      highlights.LspReferenceText = { gui = 'underline' }
      highlights.LspReferenceRead = { gui = 'underline' }
      highlights.LspReferenceWrite = { gui = 'underline' }
      highlights.SnacksIndent = { fg = colors.line }
      highlights.SnacksIndentScope = { fg = colors.fg }
      -- highlights.DiffChange = highlights.MiniDiffOverContext
      -- highlights.DiffText = highlights.MiniDiffOverChange
      -- More contrasty variants
      -- highlights.DiffChange = { fg = colors.delta, bg = utilities.blend(colors.delta, colors.bg, 0.2) }
      -- highlights.DiffText = { fg = colors.delta, bg = utilities.blend(colors.delta, colors.bg, 0.4) }
      -- highlights.DiffDelete = highlights.MiniDiffOverDelete
      -- highlights.DiffAdd = highlights.MiniDiffOverAdd
      highlights.DiffviewFilePanelSelected = { fg = colors.number, gui = 'bold' }
      highlights.MiniStatusLineModeNormal = { bg = colors.search, fg = colors.fg, gui = 'bold' }
      highlights.MiniStatusLineModeInsert = { bg = colors.plus, fg = colors.line, gui = 'bold' }
      highlights.MiniStatusLineModeVisual = { bg = colors.func, fg = colors.line, gui = 'bold' }
      highlights.MiniStatusLineDevInfo = { bg = utilities.blend(colors.search, colors.bg, 0.5), fg = colors.fg }
      highlights.MiniStatusLineFileInfo = { bg = utilities.blend(colors.search, colors.bg, 0.5), fg = colors.fg }
      highlights.CurSearch = { bg = colors.warning, fg = colors.bg }
      highlights.QuickFixLine = { fg = colors.number, gui = 'bold' }

      highlights.MiniFilesBorder = { fg = colors.search }

      highlights.GitConflictAncestorLabel = { bg = colors.search }
      highlights.GitConflictAncestor = { bg = colors.search }

      -- Formatting for Markdown
      -- highlights.RenderMarkdownBullet = { fg = colors.keyword }
      -- highlights.RenderMarkdownTableRow = { fg = colors.keyword }
      -- highlights.RenderMarkdownCode = { bg = colors.line }
      --
      -- highlights['@markup.strong'] = { fg = colors.keyword, gui = 'bold' }
      -- highlights['@markup.italic'] = { fg = colors.keyword, gui = 'italic' }
      -- highlights['@markup.heading.1'] = { fg = colors.constant, gui = 'bold' }
      -- highlights['@markup.heading.2'] = { fg = colors.parameter, gui = 'bold' }
      -- highlights['@markup.heading.3'] = { fg = colors.type, gui = 'bold' }
      -- highlights['@markup.heading.4'] = { fg = colors.operator, gui = 'bold' }
      -- highlights['@markup.heading.5'] = { fg = colors.plus, gui = 'bold' }
      -- highlights['@markup.heading.6'] = { fg = colors.func, gui = 'bold' }
      --
      -- local groups = {}
      -- for i = 1, 6 do
      --   groups['h' .. i] = highlights['@markup.heading.' .. i]
      -- end
      -- local cs = require('mini.colors').as_colorscheme { groups = groups }
      -- cs = cs:chan_invert('lightness', { gamut_clip = 'cusp' })
      -- cs = cs:chan_add('lightness', -5)
      -- for i = 1, 6 do
      --   local bg = cs.groups['h' .. i].fg
      --   highlights['RenderMarkdownH' .. i .. 'Bg'] = { bg = bg }
      -- end
      -- End formatting for Markdown
    end,
  }

  vim.cmd.colorscheme 'vague'
end)
