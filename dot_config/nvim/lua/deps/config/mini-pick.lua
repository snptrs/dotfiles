local function create_window_config(height, width)
  return {
    anchor = 'NW',
    height = height,
    width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end

local small_window = function()
  return create_window_config(20, 80)
end

local big_window = function()
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return create_window_config(height, width)
end

local wide_window = function()
  local height = 20
  local width = math.floor(0.618 * vim.o.columns)
  return create_window_config(height, width)
end

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

    require('mini.extra').pickers.lsp(opts, { window = { config = wide_window } })
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

  if scope == 'references' then
    require('mini.extra').pickers.lsp({ scope = 'references' }, { window = { config = wide_window } })
    return
  end

  if scope == 'workspace_symbol' then
    vim.lsp.buf.workspace_symbol(get_symbol_query(), { on_list = on_list })
    return
  end

  vim.lsp.buf[scope] { on_list = on_list }
end

local choose_marked = function()
  local mappings = MiniPick.get_picker_opts().mappings
  vim.api.nvim_input(mappings.choose_marked)
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
      '<leader>fv',
      function()
        require('mini.extra').pickers.visit_paths({
          recency_weight = 1,
        }, {
          window = {
            config = small_window,
          },
        })
      end,
      desc = 'Visit paths',
    },
    {
      '<space><space>',
      function()
        require('mini.pick').builtin.buffers({ include_current = false }, {
          mappings = {
            wipeout = {
              char = '<C-d>',
              func = function()
                local picker = require 'mini.pick'
                vim.api.nvim_buf_delete(picker.get_picker_matches().current.bufnr, {})
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
        lsp_picker('definition', true)
      end,
      desc = 'Goto definition',
    },
    {
      'gr',
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
      options = {
        content_from_bottom = false,
      },
      window = {
        config = small_window,
      },
      mappings = {
        choose_all = { char = '<C-q>', func = choose_marked },
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
