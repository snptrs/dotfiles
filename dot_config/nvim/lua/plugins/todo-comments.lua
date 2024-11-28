return {
  'folke/todo-comments.nvim',
  keys = {
    { '<leader>ft', '<cmd>TodoTelescope<cr>', noremap = true, silent = true, desc = 'Find [t]odos' },
    { '<leader>tt', '<cmd>TodoTrouble<cr>', noremap = true, silent = true, desc = 'Open [t]odos in Trouble' },
  },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
}
