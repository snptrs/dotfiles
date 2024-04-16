return {
  'github/copilot.vim',
  config = function()
    vim.keymap.set('i', '<Right>', 'copilot#Accept("\\<Right>")', {
      expr = true,
      silent = true,
      replace_keycodes = false,
    })
    vim.g.copilot_no_tab_map = true
  end,
}
