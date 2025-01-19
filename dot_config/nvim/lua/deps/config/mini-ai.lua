local gen_spec = require('mini.ai').gen_spec
local gen_ai_spec = require('mini.extra').gen_ai_spec

return {
  opts = {
    n_lines = 500,
    custom_textobjects = {
      o = gen_spec.treesitter { -- code block
        a = { '@block.outer', '@conditional.outer', '@loop.outer' },
        i = { '@block.inner', '@conditional.inner', '@loop.inner' },
      },
      k = gen_spec.treesitter {
        i = '@assignment.lhs',
        a = '@assignment.lhs',
      },
      f = gen_spec.treesitter { a = '@function.outer', i = '@function.inner' }, -- function
      c = gen_spec.treesitter { a = '@class.outer', i = '@class.inner' }, -- class
      t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
      e = { -- Word with case
        { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
        '^().*()$',
      },
      B = gen_ai_spec.buffer(),
      D = gen_ai_spec.diagnostic(),
      I = gen_ai_spec.indent(),
      L = gen_ai_spec.line(),
      N = gen_ai_spec.number(),
    },
  },

  func = function()
    vim.schedule(function()
      ---@type table<string, string|table>
      local keys = {
        [' '] = 'Whitespace',
        ['"'] = 'Balanced "',
        ["'"] = "Balanced '",
        ['`'] = 'Balanced `',
        ['('] = 'Balanced (',
        [')'] = 'Balanced ) ',
        ['>'] = 'Balanced > ',
        ['<lt>'] = 'Balanced <',
        [']'] = 'Balanced ] ',
        ['['] = 'Balanced [',
        ['}'] = 'Balanced } ',
        ['{'] = 'Balanced {',
        ['?'] = 'User Prompt',
        _ = 'Underscore',
        a = 'Argument',
        b = 'Balanced ), ], }',
        c = 'Class',
        d = 'Digit(s)',
        e = 'Word in CamelCase & snake_case',
        f = 'Function',
        g = 'Entire file',
        k = 'Key',
        o = 'Block, conditional, loop',
        q = 'Quote `, ", \'',
        t = 'Tag',
      }

      local table = {}
      for key, name in pairs(keys) do
        vim.list_extend(table, {
          { 'i' .. key, desc = name },
          { 'a' .. key, desc = name },
          { 'in' .. key, desc = name },
          { 'an' .. key, desc = name },
          { 'il' .. key, desc = name },
          { 'al' .. key, desc = name },
        })
      end
      require('which-key').add {
        mode = { 'o', 'x' },
        table,
      }
    end)
  end,
}
