local module_names = {
  'ai',
  'align',
  'comment',
  'extra',
  'files',
  'indentscope',
  'operators',
  'pairs',
  'pick',
  'surround',
}

local function merge_module_keys()
  local keys = {}
  for _, name in ipairs(module_names) do
    local module = require('plugins.mini.' .. name)
    if module.keys then
      vim.list_extend(keys, module.keys)
    end
  end
  return keys
end

return {
  'echasnovski/mini.nvim',
  version = false,
  event = 'VeryLazy',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = { enable_autocmd = false },
  },
  keys = merge_module_keys(),

  config = function()
    for _, name in ipairs(module_names) do
      require('plugins.mini.' .. name).setup()
    end
  end,
}
