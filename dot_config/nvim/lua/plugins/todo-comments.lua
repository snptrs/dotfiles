return {
  'folke/todo-comments.nvim',
  keys = {
    { '<leader>tt', '<cmd>TodoTrouble<cr>', noremap = true, silent = true, desc = 'Open [t]odos in Trouble' },
  },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
}
