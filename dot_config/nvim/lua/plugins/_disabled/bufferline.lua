return {
  'akinsho/bufferline.nvim',
  enabled = false,
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level)
        local icon = level:match 'error' and ' ' or ''
        return ' ' .. icon .. count
      end,
      offsets = { { filetype = 'NvimTree', text = 'Files', text_align = 'center' } },
      vim.keymap.set('n', '<leader>bg', ':BufferLinePick<CR>', { desc = 'Go to open buffer' }),
      vim.keymap.set('n', '<leader>bD', ':BufferLinePickClose<CR>', { desc = 'Close an open buffer' }),
    },
  },
}
