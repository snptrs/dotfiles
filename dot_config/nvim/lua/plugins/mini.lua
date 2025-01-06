return {
  'echasnovski/mini.nvim',
  version = false,
  event = 'VeryLazy',
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring', opts = { enable_autocmd = false } },
  config = function()
    require('mini.files').setup {
      windows = {
        preview = true,
        width_preview = 60,
      },
      options = {
        use_as_default_explorer = false,
      },
    }

    require('mini.align').setup {}

    require('mini.comment').setup {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
        end,
      },
    }

    require('mini.surround').setup {
      highlight_duration = 1000,
      mappings = {
        add = 'gza', -- Add surrounding in Normal and Visual modes
        delete = 'gzd', -- Delete surrounding
        find = 'gzf', -- Find surrounding (to the right)
        find_left = 'gzF', -- Find surrounding (to the left)
        highlight = 'gzh', -- Highlight surrounding
        replace = 'gzr', -- Replace surrounding
        update_n_lines = 'gzn', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    }

    require('mini.indentscope').setup {
      symbol = '▏',
      options = {
        try_as_border = true,
        indent_at_cursor = true,
      },
      draw = {
        delay = 100,
        priority = 2,
        animation = function(s, n)
          return s / n * 30
        end,
      },
    }

    require('mini.operators').setup {
      replace = {
        prefix = 'gR',
        reindent_linewise = true,
      },
    }

    require('mini.pick').setup()
    require('mini.extra').setup()

    -- ## mini.ai ##
    local ai_opts = function()
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
    end
    require('mini.ai').setup(ai_opts())
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
