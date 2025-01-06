return {
  setup = function()
    require('mini.files').setup {
      windows = {
        preview = true,
        width_preview = 60,
      },
      options = {
        use_as_default_explorer = false,
      },
    }
  end
}
