return {
  'rose-pine/neovim',
  lazy = false,
  priority = 1000,
  config = function()
    require('rose-pine').setup {
      disable_italics = false,
      bold_vert_split = false,
      dim_nc_background = true,
      groups = {
        punctuation = 'subtle',
      },
      highlight_groups = {
        PmenuSel = { bg = '#353A45', fg = 'NONE' },
        Pmenu = { fg = '#C5CDD9', bg = '#22252A' },

        CmpItemAbbrDeprecated = { fg = '#7E8294', bg = 'NONE', strikethrough = true },
        CmpItemAbbrMatch = { fg = '#82AAFF', bg = 'NONE', bold = true },
        CmpItemAbbrMatchFuzzy = { fg = '#82AAFF', bg = 'NONE', bold = true },
        CmpItemMenu = { fg = '#C792EA', bg = 'NONE', italic = true },

        CmpItemKindField = { fg = '#EED8DA', bg = '#B5585F' },
        CmpItemKindProperty = { fg = '#EED8DA', bg = '#B5585F' },
        CmpItemKindEvent = { fg = '#EED8DA', bg = '#B5585F' },

        CmpItemKindText = { fg = '#C3E88D', bg = '#9FBD73' },
        CmpItemKindEnum = { fg = '#C3E88D', bg = '#9FBD73' },
        CmpItemKindKeyword = { fg = '#C3E88D', bg = '#9FBD73' },

        CmpItemKindConstant = { fg = '#FFE082', bg = '#D4BB6C' },
        CmpItemKindConstructor = { fg = '#FFE082', bg = '#D4BB6C' },
        CmpItemKindReference = { fg = '#FFE082', bg = '#D4BB6C' },

        CmpItemKindFunction = { fg = '#EADFF0', bg = '#A377BF' },
        CmpItemKindStruct = { fg = '#EADFF0', bg = '#A377BF' },
        CmpItemKindClass = { fg = '#EADFF0', bg = '#A377BF' },
        CmpItemKindModule = { fg = '#EADFF0', bg = '#A377BF' },
        CmpItemKindOperator = { fg = '#EADFF0', bg = '#A377BF' },

        CmpItemKindVariable = { fg = '#C5CDD9', bg = '#7E8294' },
        CmpItemKindFile = { fg = '#C5CDD9', bg = '#7E8294' },

        CmpItemKindUnit = { fg = '#F5EBD9', bg = '#D4A959' },
        CmpItemKindSnippet = { fg = '#F5EBD9', bg = '#D4A959' },
        CmpItemKindFolder = { fg = '#F5EBD9', bg = '#D4A959' },

        CmpItemKindMethod = { fg = '#DDE5F5', bg = '#6C8ED4' },
        CmpItemKindValue = { fg = '#DDE5F5', bg = '#6C8ED4' },
        CmpItemKindEnumMember = { fg = '#DDE5F5', bg = '#6C8ED4' },

        CmpItemKindInterface = { fg = '#D8EEEB', bg = '#58B5A8' },
        CmpItemKindColor = { fg = '#D8EEEB', bg = '#58B5A8' },
        CmpItemKindTypeParameter = { fg = '#D8EEEB', bg = '#58B5A8' },
      },
    }
    vim.cmd 'colorscheme rose-pine'
  end,
}
