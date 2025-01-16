return {
  setup = function()
    require('mini.misc').setup()

    require('mini.misc').setup_restore_cursor()
    require('mini.misc').setup_auto_root()
  end,
}
