return {
  'onsails/lspkind.nvim',
  init = function()
    local lspkind = require 'lspkind'
    lspkind.init {
      symbol_map = {
        Supermaven = '',
      },
    }

    vim.api.nvim_set_hl(0, 'CmpItemKindSupermaven', { fg = '#D4A959' })
  end,
}
