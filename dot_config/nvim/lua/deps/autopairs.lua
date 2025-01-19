deps.later(function()
  deps.add {
    source = 'windwp/nvim-ts-autotag',
  }

  ---@diagnostic disable-next-line: missing-fields
  require('nvim-ts-autotag').setup {
    opts = {
      enable_close = true, -- Auto close tags
      enable_rename = false, -- Auto rename pairs of tags
      enable_close_on_slash = true, -- Auto close on trailing </
    },
  }
end)
