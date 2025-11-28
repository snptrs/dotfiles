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
      highlights.CurSearch = { bg = colors.warning, fg = colors.bg }
      highlights.QuickFixLine = { fg = colors.number, gui = 'bold' }

      highlights.MiniFilesBorder = { fg = colors.search }

      highlights.GitConflictAncestorLabel = { bg = colors.search }
      highlights.GitConflictAncestor = { bg = colors.search }
    end,
  }

  vim.cmd.colorscheme 'vague'
end)
