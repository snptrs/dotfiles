return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {

    -- Trouble keymaps
    vim.keymap.set('n', '<leader>xx', function()
      require('trouble').toggle()
    end, { desc = 'Toggle [T]rouble' }),
    vim.keymap.set('n', '<leader>xw', function()
      require('trouble').toggle 'workspace_diagnostics'
    end, { desc = '[T]rouble workspace diagnostics' }),
    vim.keymap.set('n', '<leader>xd', function()
      require('trouble').toggle 'document_diagnostics'
    end, { desc = '[T]rouble document diagnostics' }),
    vim.keymap.set('n', '<leader>xq', function()
      require('trouble').toggle 'quickfix'
    end, { desc = '[T]rouble quickfix' }),
    vim.keymap.set('n', '<leader>xl', function()
      require('trouble').toggle 'loclist'
    end, { desc = '[T]rouble loclist' }),
    vim.keymap.set('n', 'gR', function()
      require('trouble').toggle 'lsp_references'
    end, { desc = '[T]rouble LSP references' }),
  },
}
