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
      highlights.LspReferenceText = { underline = true }
      highlights.LspReferenceRead = { underline = true }
      highlights.LspReferenceWrite = { underline = true }
      highlights.SnacksIndent = { fg = colors.line }
      highlights.SnacksIndentScope = { fg = colors.fg }
      highlights.CurSearch = { bg = colors.warning, fg = colors.bg }
      highlights.QuickFixLine = { fg = colors.number, bold = true }
      --
      highlights.MiniFilesBorder = { fg = colors.search }

      highlights.GitConflictAncestorLabel = { bg = colors.search }
      highlights.GitConflictAncestor = { bg = colors.search }
    end,
  }

  vim.cmd.colorscheme 'vague'
end)
