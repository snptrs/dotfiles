return {
  setup = function()
    require('mini.indentscope').setup {
      symbol = '▏',
      options = {
        try_as_border = true,
        indent_at_cursor = true,
      },
      draw = {
        delay = 100,
        priority = 2,
        animation = function(s, n)
          return s / n * 30
        end,
      },
    }

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Disable indentscope for certain filetypes',
      pattern = {
        'help',
        'Trouble',
        'trouble',
        'lazy',
        'mason',
        'notify',
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
