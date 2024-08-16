return {
  'nvim-telescope/telescope-file-browser.nvim',
  lazy = true,
  keys = { { '<leader>fb', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>', desc = '[F]ile [B]rowser at current path' } },
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
}
