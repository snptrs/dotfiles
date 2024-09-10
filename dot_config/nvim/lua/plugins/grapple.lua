return {
  'cbochs/grapple.nvim',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
  },
  opts = {
    scope = 'git_branch',
    icons = true,
    -- quick_select = '123456789',
  },
  keys = {
    { '<leader>,', '<cmd>Grapple toggle_tags<cr>', desc = 'Toggle tags menu' },
    { '<leader>m', '<cmd>Grapple toggle<cr>', desc = 'Toggle tag' },
    { '<leader>]', '<cmd>Grapple cycle_tags next<cr>', desc = 'Go to next tag' },
    { '<leader>[', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Go to previous tag' },
  },
}
