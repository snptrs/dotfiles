return {
  'zk-org/zk-nvim',
  enabled = false,
  config = function()
    require('zk').setup {
      picker = 'telescope',
    }
  end,
}
