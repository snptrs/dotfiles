return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    on_attach = function()
      vim.keymap.set('n', '<leader>dio', '<cmd>TSToolsOrganizeImports<cr>', { desc = 'Organise imports' })
      vim.keymap.set('n', '<leader>dis', '<cmd>TSToolsSortImports<cr>', { desc = 'Sort imports' })
      vim.keymap.set('n', '<leader>dr', '<cmd>TSToolsRemoveUnused<cr>', { desc = 'Remove all unused statements' })
      vim.keymap.set('n', '<leader>da', '<cmd>TSToolsAddMissingImports<cr>', { desc = 'Add missing imports' })
      vim.keymap.set('n', '<leader>dn', '<cmd>TSToolsRenameFile<cr>', { desc = 'Rename current file' })

      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('TS_add_missing_imports', { clear = true }),
        desc = 'TS_add_missing_imports',
        pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
        callback = function()
          vim.cmd [[TSToolsOrganizeImports]]
          vim.cmd 'write'
        end,
      })
    end,
    settings = {
      tsserver_file_preferences = {},
    },
  },
}
