return {
  setup = function()
    require('mini.operators').setup {
      replace = {
        prefix = 'gR',
        reindent_linewise = true,
      },
    }
  end
}
