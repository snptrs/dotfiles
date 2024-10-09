return {
  {
    'nvchad/minty',
    lazy = true,
    keys = {
      {
        '<leader>Cc',
        function()
          require('minty.huefy').open { border = true }
        end,
        desc = 'Minty hues',
      },
      {
        '<leader>Cs',
        function()
          require('minty.shades').open { border = false }
        end,
        desc = 'Minty shades',
      },
    },
    dependencies = { 'nvchad/volt', lazy = true },
  },
}
