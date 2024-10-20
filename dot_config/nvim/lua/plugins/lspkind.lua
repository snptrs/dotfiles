return {
  'onsails/lspkind.nvim',
  enabled = false,
  init = function()
    local lspkind = require 'lspkind'
    lspkind.init {
      symbol_map = {
        Supermaven = '',
        Copilot = '',
      },
    }

    vim.api.nvim_set_hl(0, 'CmpItemKindSupermaven', { fg = '#D4A959' })
    vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#D4A959' })
  end,
}
