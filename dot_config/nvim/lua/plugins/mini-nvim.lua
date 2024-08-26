return {
  {
    'echasnovski/mini.operators',
    version = false,
    opts = {},
  },
  {
    {
      'echasnovski/mini.ai',
      event = 'VeryLazy',
      opts = function()
        local ai = require 'mini.ai'
        return {
          n_lines = 500,
          custom_textobjects = {
            o = ai.gen_spec.treesitter { -- code block
              a = { '@block.outer', '@conditional.outer', '@loop.outer' },
              i = { '@block.inner', '@conditional.inner', '@loop.inner' },
            },
            k = ai.gen_spec.treesitter {
              i = '@assignment.lhs',
              a = '@assignment.lhs',
            },
            f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' }, -- function
            c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' }, -- class
            t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
            d = { '%f[%d]%d+' }, -- digits
            e = { -- Word with case
              { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
              '^().*()$',
            },
            g = function() -- Entire buffer
              local from = { line = 1, col = 1 }
              local to = {
                line = vim.fn.line '$',
                col = math.max(vim.fn.getline('$'):len(), 1),
              }
              return { from = from, to = to }
            end,
          },
        }
      end,

      config = function(_, opts)
        require('mini.ai').setup(opts)
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
    },
  },
}
