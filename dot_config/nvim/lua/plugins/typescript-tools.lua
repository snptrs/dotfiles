return {
  'pmizio/typescript-tools.nvim',
  enabled = false,
  lazy = 'true',
  event = { 'BufEnter *.js,*jsx', 'BufEnter *.jsx', 'BufEnter *.ts', 'BufEnter *.tsx' },
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    on_attach = function(client, bufnr)
      vim.keymap.set('n', '<leader>dio', '<cmd>TSToolsOrganizeImports<cr>', { desc = 'Organise imports' })
      vim.keymap.set('n', '<leader>dis', '<cmd>TSToolsSortImports<cr>', { desc = 'Sort imports' })
      vim.keymap.set('n', '<leader>dr', '<cmd>TSToolsRemoveUnused<cr>', { desc = 'Remove all unused statements' })
      vim.keymap.set('n', '<leader>da', '<cmd>TSToolsAddMissingImports<cr>', { desc = 'Add missing imports' })
      vim.keymap.set('n', '<leader>dn', '<cmd>TSToolsRenameFile<cr>', { desc = 'Rename current file' })
    end,
    settings = {
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
}
