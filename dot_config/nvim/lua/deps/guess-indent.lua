deps.later(function()
  deps.add {
    source = 'nmac427/guess-indent.nvim',
  }
  require('guess-indent').setup {
    override_editorconfig = true,
  }
end)
