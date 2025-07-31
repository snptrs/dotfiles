local MiniPick = require 'mini.pick'

local find_ignored_files = function()
  MiniPick.builtin.cli(
    {
      command = {
        'rg',
        '--files',
        '--hidden',
        '--no-ignore',
        '-g',
        '!/**/.git',
        '-g',
        '!/**/node_modules',
        '-g',
        '!/**/vendor',
        '-g',
        '!/**/public/build',
      },
    },
    {
      -- Give this picker a readable name so it is shown in the UI
      source = { name = 'Files (include ignored)' },
    }
  )
end

local find_absolutely_all_files = function()
  MiniPick.builtin.cli(
    {
      command = {
        'rg',
        '--files',
        '--hidden',
        '--no-ignore',
        '-g',
        '!/**/.git',
        '-g',
        '!/**/public/build',
      },
    },
    {
      -- Clear label so it stands out when resuming pickers
      source = { name = 'All files' },
    }
  )
end

local switch_to_ignored = function()
  local query = MiniPick.get_picker_query()
  MiniPick.stop()

  find_ignored_files()
  local transfer_query = function()
    if query then
      MiniPick.set_picker_query(query)
    end
  end
  vim.api.nvim_create_autocmd('User', { pattern = 'MiniPickStart', once = true, callback = transfer_query })
end

MiniPick.registry.buffers = function(local_opts)
  local wipeout = function()
    vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
  end
  local extra = {
    mappings = { wipeout = { char = '<C-d>', func = wipeout } },
  }
  return MiniPick.builtin.buffers(local_opts, extra)
end

return {
  keys = {
    {
      '<leader>ff',
      function()
        MiniPick.builtin.files(nil)
      end,
      desc = 'Find files',
    },
    {
      '<leader>fF',
      find_ignored_files,
      desc = 'Find files (include ignored)',
    },
    {
      '<leader>f!',
      find_absolutely_all_files,
      desc = 'Find files (absolutely everything)',
    },
    {
      '<leader>fg',
      function()
        MiniPick.builtin.grep_live(nil)
      end,
      desc = 'Grep files',
    },
    {
      '<leader>fr',
      function()
        MiniPick.builtin.resume()
      end,
      desc = 'Resume find',
    },
    {
      '<leader>fv',
      function()
        require('mini.extra').pickers.visit_paths {
          recency_weight = 1,
        }
      end,
      desc = 'Visit paths',
    },
    {
      '<leader>f"',
      function()
        require('mini.extra').pickers.registers()
      end,
      desc = 'Registers',
    },
    {
      '<leader>fm',
      function()
        require('mini.extra').pickers.marks()
      end,
      desc = 'Marks',
    },
    {
      '<space><space>',
      function()
        MiniPick.registry.buffers()
      end,
      desc = 'Open buffers',
    },
    {
      'gd',
      function()
        require('mini.extra').pickers.lsp { scope = 'definition' }
      end,
      desc = 'Goto definition',
    },
    {
      'grr',
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
    MiniPick.setup {
      mappings = {
        scroll_up = '<C-k>',
        scroll_down = '<C-j>',
        switch_to_ignored = { char = '<M-i>', func = switch_to_ignored },
      },
    }

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
