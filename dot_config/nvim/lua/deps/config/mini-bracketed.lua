return {
  func = function()
    local put_keys = {
      { lhs = 'p', rhs = 'p', desc = 'Put after' },
      { lhs = 'P', rhs = 'P', desc = 'Put before' },
      { lhs = ']p', rhs = ':pu<CR>', desc = 'Put after linewise' },
      { lhs = '[p', rhs = ':pu!<CR>', desc = 'Put before linewise' },
    }

    for _, mapping in ipairs(put_keys) do
      local rhs = 'v:lua.MiniBracketed.register_put_region("' .. mapping.rhs .. '")'
      vim.keymap.set({ 'n', 'x' }, mapping.lhs, rhs, { expr = true, desc = mapping.desc })
    end
  end,
}
