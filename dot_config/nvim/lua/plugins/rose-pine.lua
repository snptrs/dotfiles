return {
  'rose-pine/neovim',
  lazy = false,
  priority = 1000,
  config = function()
    require('rose-pine').setup {
      disable_italics = false,
      bold_vert_split = false,
      dim_nc_background = true,
      groups = {
        punctuation = 'subtle',
      },
    }
    vim.cmd 'colorscheme rose-pine'
  end,
}
