local small_window = function()
  local height = 20
  local width = 80
  return {
    anchor = 'NW',
    height = height,
    width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end

local big_window = function()
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return {
    anchor = 'NW',
    height = height,
    width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end

return {
  keys = {
    {
      '<leader>ff',
      function()
        require('mini.pick').builtin.files(nil, { window = {
          config = big_window,
        } })
      end,
      desc = 'Find files',
    },
    {
      '<leader>fg',
      function()
        require('mini.pick').builtin.grep_live(nil, { window = {
          config = big_window,
        } })
      end,
      desc = 'Grep files',
    },
    {
      '<leader>fr',
      function()
        require('mini.pick').builtin.resume(nil, { window = {
          config = big_window,
        } })
      end,
      desc = 'Resume find',
    },
    {
      '<space><space>',
      function()
        require('mini.pick').builtin.buffers({ include_current = false }, {
          mappings = {
            wipeout = {
              char = '<C-d>',
              func = function()
                vim.api.nvim_buf_delete(require('mini.pick').get_picker_matches().current.bufnr, {})
              end,
            },
          },
        })
      end,
      desc = 'Open buffers',
    },
    {
      'gd',
      function()
        require('mini.extra').pickers.lsp({ scope = 'definition' }, {})
      end,
      desc = 'Goto definition',
    },
    {
      'gr',
      function()
        require('mini.extra').pickers.lsp { scope = 'references' }
      end,
      desc = 'Goto references',
    },
    {
      'gD',
      function()
        require('mini.extra').pickers.lsp { scope = 'declaration' }
      end,
      desc = 'Goto declaration',
    },
    {
      'gT',
      function()
        require('mini.extra').pickers.lsp { scope = 'type_definition' }
      end,
      desc = 'Goto type definition',
    },
  },

  setup = function()
    require('mini.pick').setup {
      options = {
        content_from_bottom = false,
      },
      window = {
        config = small_window,
      },
    }

    local MiniPick = require 'mini.pick'
    local MiniExtra = require 'mini.extra'

    vim.ui.select = MiniPick.ui_select

    MiniPick.registry.registry = function()
      local items = vim.tbl_keys(MiniPick.registry)
      table.sort(items)
      local source = { items = items, name = 'Registry', choose = function() end }
      local chosen_picker_name = MiniPick.start { source = source }
      if chosen_picker_name == nil then
        return
      end
      return MiniPick.registry[chosen_picker_name]()
    end

    MiniPick.registry.projects = function()
      local cwd = vim.fn.expand '~/Code/Projects'
      local choose = function(item)
        vim.schedule(function()
          MiniPick.builtin.files(nil, { source = { cwd = item.path } })
        end)
      end
      return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
    end
  end,
}
