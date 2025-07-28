---@param scope "declaration" | "definition" | "document_symbol" | "implementation" | "references" | "type_definition" | "workspace_symbol"
---@param autojump boolean? If there is only one result it will jump to it.
local function lsp_picker(scope, autojump)
  ---@return string
  local function get_symbol_query()
    return vim.fn.input 'Symbol: '
  end

  if not autojump then
    local opts = { scope = scope }

    if scope == 'workspace_symbol' then
      opts.symbol_query = get_symbol_query()
    end

    require('mini.extra').pickers.lsp(opts)
    return
  end

  ---@param opts vim.lsp.LocationOpts.OnList
  local function on_list(opts)
    vim.fn.setqflist({}, ' ', opts)

    if #opts.items == 1 then
      vim.cmd.cfirst()
    else
      require('mini.extra').pickers.list({ scope = 'quickfix' }, { source = { name = opts.title } })
    end
  end

  if scope == 'workspace_symbol' then
    vim.lsp.buf.workspace_symbol(get_symbol_query(), { on_list = on_list })
    return
  end

  vim.lsp.buf[scope] { on_list = on_list }
end

local find_ignored_files = function()
  MiniPick.builtin.cli {
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
  }
end

local switch_to_ignored = function()
  local query = MiniPick.get_picker_query()
  MiniPick.stop()

  find_ignored_files()
  local transfer_query = function()
    MiniPick.set_picker_query(query)
  end
  vim.api.nvim_create_autocmd('User', { pattern = 'MiniPickStart', once = true, callback = transfer_query })
end

require('mini.pick').registry.buffers = function(local_opts, opts)
  -- Delete the current buffer
  local wipeout_cur = function()
    vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
  end

  -- Map <C-d> to delete the buffer
  local buffer_mappings = { wipeout = { char = '<C-d>', func = wipeout_cur } }

  -- Merge options
  opts = vim.tbl_deep_extend('force', {
    mappings = buffer_mappings,
  }, opts or {})

  return MiniPick.builtin.buffers(local_opts, opts)
end

return {
  keys = {
    {
      '<leader>ff',
      function()
        require('mini.pick').builtin.files(nil)
      end,
      desc = 'Find files',
    },
    {
      '<leader>fF',
      find_ignored_files,
      desc = 'Find files (include ignored)',
    },
    {
      '<leader>fg',
      function()
        require('mini.pick').builtin.grep_live(nil)
      end,
      desc = 'Grep files',
    },
    {
      '<leader>fr',
      function()
        require('mini.pick').builtin.resume()
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
        require('mini.pick').registry.buffers()
      end,
      desc = 'Open buffers',
    },
    {
      'gd',
      function()
        lsp_picker('definition', true)
      end,
      desc = 'Goto definition',
    },
    {
      'grr',
      function()
        lsp_picker('references', true)
      end,
      desc = 'Goto references',
    },
    {
      'gD',
      function()
        lsp_picker('declaration', true)
      end,
      desc = 'Goto declaration',
    },
    {
      'gT',
      function()
        lsp_picker('type_definition', true)
      end,
      desc = 'Goto type definition',
    },
  },

  setup = function()
    require('mini.pick').setup {
      mappings = {
        scroll_up = '<C-k>',
        switch = { char = '<M-i>', func = switch_to_ignored },
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
