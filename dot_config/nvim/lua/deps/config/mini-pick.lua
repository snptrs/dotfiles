local MiniPick = require 'mini.pick'

local find_ignored_files = function()
  MiniPick.builtin.cli({
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
  }, {
    source = { name = 'Files (include ignored)' },
  })
end

local find_absolutely_all_files = function()
  MiniPick.builtin.cli({
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
  }, {
    source = { name = 'Absolutely all files' },
  })
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
      '<leader>fs',
      function()
        MiniPick.builtin.grep_live(nil)
      end,
      desc = 'Find string',
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
      '<leader>fk',
      function()
        MiniPick.registry.keymaps()
      end,
      desc = 'Keymaps',
    },
    {
      '<leader>fh',
      function()
        MiniPick.registry.help()
      end,
      desc = 'Help',
    },
    {
      '<leader>fb',
      function()
        MiniExtra.pickers.buf_lines { scope = 'current' }
      end,
      desc = 'Buffer lines',
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

    MiniPick.registry.buffers = function()
      local ns_id = vim.api.nvim_create_namespace 'pick-buffers'
      local show = function(buf_id, items_to_show, query)
        MiniPick.default_show(buf_id, items_to_show, query, { show_icons = true })

        -- Show `[+] ` prefix for items representing modified buffers
        vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)
        local opts = { virt_text = { { '[+] ', 'Special' } }, virt_text_pos = 'inline' }
        for i, item in ipairs(items_to_show) do
          if vim.bo[item.bufnr].modified then
            vim.api.nvim_buf_set_extmark(buf_id, ns_id, i - 1, 0, opts)
          end
        end
      end

      local wipeout = function()
        vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
      end

      MiniPick.builtin.buffers(nil, {
        source = { show = show },
        mappings = { wipeout = { char = '<C-d>', func = wipeout } },
      })
    end
  end,
}
