return {
  setup = function()
    require('mini.pairs').setup {
      mappings = {
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^`\\].', register = { cr = false } },
      },
    }
  end,
}
