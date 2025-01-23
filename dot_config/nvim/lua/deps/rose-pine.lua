deps.now(function()
  deps.add {
    source = 'rose-pine/neovim',
    name = 'rose-pine',
  }

  ---@diagnostic disable-next-line: missing-fields
  require('rose-pine').setup {
    disable_italics = true,
    bold_vert_split = false,
    dim_nc_background = true,
    groups = {
      punctuation = 'subtle',
    },

    highlight_groups = {
      Comment = { italic = true },
      Keyword = { italic = true },
      LspSignatureActiveParameter = { bg = 'iris', fg = 'overlay' },
      YankyYanked = { fg = 'text', bg = 'gold', blend = 75 },
      StatusLine = { bg = 'base', fg = 'base' },
      ['@keyword.conditional'] = { italic = true },
      ['@keyword.control'] = { italic = true },
      ['@keyword.repeat'] = { italic = true },
      ['@keyword.return'] = { italic = true },
      ['@variable.member'] = { italic = true },
      ['@variable.parameter.bash'] = { fg = '' },
      ['@markup.link.label.javascript'] = { underline = false },

      PmenuSel = { bg = '#353A45' },
      Pmenu = { fg = '#C5CDD9', bg = '#22252A' },

      MiniPickMatchCurrent = { fg = 'gold', bold = true },
      MiniPickMatchMarked = { fg = 'love', bold = true },

      GitConflictAncestorLabel = { bg = 'overlay' },
      GitConflictAncestor = { bg = 'overlay' },

      WinBar = { fg = 'foam', bg = 'overlay' },
      DiffText = { blend = 25 },
      DiffChange = { blend = 10 },
      DiffDelete = { blend = 30 },
    },
  }

  vim.cmd 'colorscheme rose-pine'
end)
