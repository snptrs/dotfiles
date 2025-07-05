deps.later(function()
  deps.add {
    source = 'monaqa/dial.nvim',
  }

  local augend = require 'dial.augend'
  require('dial.config').augends:register_group {
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias['%Y/%m/%d'],
      augend.constant.alias.bool,
      augend.semver.alias.semver,
      augend.constant.new { elements = { 'let', 'const' } },
      augend.constant.new { elements = { 'private', 'public', 'protected' } },
      augend.constant.new { elements = { 'GET', 'POST', 'PATCH', 'DELETE' } },
    },
  }

  local dial_map = require 'dial.map'
  vim.keymap.set('n', '<C-a>', function()
    return dial_map.inc_normal()
  end, { desc = 'Increment', expr = true })
  vim.keymap.set('n', '<C-x>', function()
    return dial_map.dec_normal()
  end, { desc = 'Decrement', expr = true })
end)
