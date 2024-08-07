return {
  'folke/zen-mode.nvim',
  opts = {
    window = {
      backdrop = 1,
      options = {
        signcolumn = 'no', -- disable signcolumn
        -- number = false, -- disable number column
        relativenumber = false, -- disable relative numbers
        -- cursorline = false, -- disable cursorline
        cursorcolumn = false, -- disable cursor column
        -- foldcolumn = "0", -- disable fold column
        list = false, -- disable whitespace characters
      },
    },
    on_open = function()
      vim.o.cmdheight = 1
    end,
    on_close = function()
      vim.o.cmdheight = 0
    end,
  },
}
