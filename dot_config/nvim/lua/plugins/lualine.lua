return {
  'nvim-lualine/lualine.nvim',
  event = 'ColorScheme',
  config = function()
    local function diff_source()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end

    local host_map = {
      ['Seans-MacBook-Pro.local'] = 'MBP',
      ['Seans-iMac.local'] = 'Mac',
    }

    local lsp_map = {
      ['copilot'] = '',
      ['lua_ls'] = '',
      ['typescript-tools'] = '',
      ['eslint'] = '',
      ['cssmodules_ls'] = '',
      ['intelephense'] = '',
      ['jsonls'] = '',
    }

    local function get_lsps()
      local lsp_clients = vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf() }
      local client_names = {}
      for _, client in ipairs(lsp_clients) do
        table.insert(client_names, lsp_map[client.name] or client.name)
      end
      local client_names_str = table.concat(client_names, '  ')
      return client_names_str
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'rose-pine',
        -- component_separators = '|',
        -- section_separators = '',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          'mode',
          {
            require('noice').api.statusline.mode.get,
            cond = require('noice').api.statusline.mode.has,
          },
          function()
            local statusline = require 'arrow.statusline'
            return statusline.text_for_statusline_with_icons()
          end,
        },
        lualine_b = {
          { 'b:gitsigns_head', icon = '' },
          { 'diff', source = diff_source },
        },
        lualine_c = {
          { 'filename', path = 1 },
        },
        lualine_x = {
          { get_lsps, color = { fg = '#c4a7e7' }, padding = 2 },
          { 'filetype' },
        },
        lualine_y = {
          {
            'hostname',
            fmt = function(res)
              return host_map[res] or ''
            end,
          },
        },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
