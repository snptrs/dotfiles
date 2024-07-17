return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    spec = {
      { '<leader>c', group = 'Code' },
      { '<leader>d', group = 'Document' },
      { '<leader>g', group = 'Git' },
      { '<leader>gd', group = 'Diff' },
      { '<leader>h', group = 'More git' },
      { '<leader>s', group = 'Session' },
      { '<leader>w', group = 'Workspace' },
      { '<leader>x', group = 'Trouble' },
    },
  },
}
