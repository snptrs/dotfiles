return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
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
      ['cssls'] = '',
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

    local custom_fname = require('lualine.components.filename'):extend()
    local highlight = require 'lualine.highlight'
    local default_status_colors = { saved = '#fff', modified = '#eb6f92' }

    function custom_fname:init(options)
      custom_fname.super.init(self, options)
      self.status_colors = {
        saved = highlight.create_component_highlight_group({ fg = default_status_colors.saved }, 'filename_status_saved', self.options),
        modified = highlight.create_component_highlight_group({ fg = default_status_colors.modified }, 'filename_status_modified', self.options),
      }
      if self.options.color == nil then
        self.options.color = ''
      end
    end

    function custom_fname:update_status()
      local data = custom_fname.super.update_status(self)
      data = highlight.component_format_highlight(vim.bo.modified and self.status_colors.modified or self.status_colors.saved) .. data
      return data
    end

    local trouble = require 'trouble'
    local symbols = trouble.statusline {
      mode = 'symbols',
      groups = {},
      title = false,
      filter = {
        range = true,
        any = {
          { kind = 'Class' },
          { kind = 'Constructor' },
          { kind = 'Function' },
          { kind = 'Interface' },
          { kind = 'Method' },
          { kind = 'TypeParameter' },
        },
      },
      format = '{kind_icon}{symbol.name:Normal}',
      -- The following line is needed to fix the background color
      -- Set it to the lualine section you want to use
      hl_group = 'lualine_c_normal',
    }

    local winbar_config = {
      lualine_a = {},
      lualine_b = { { 'filetype', icon_only = true } },
      lualine_c = {
        {
          custom_fname,
          newfile_status = true,
          symbols = {
            modified = '[+]', -- Text to show when the file is modified.
            readonly = '', -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]', -- Text to show for newly created file before first write
          },
        },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'rose-pine',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { 'trouble', 'NeogitStatus', 'NeogitCommitView' },
          winbar = { 'trouble', 'aerial', 'oil', 'NeogitStatus', 'NeogitCommitView' },
        },
      },
      extensions = { 'oil', 'lazy', 'aerial', 'man' },
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
          { 'diagnostics', sources = { 'nvim_diagnostic' } },
          { 'filename', path = 1 },
          {
            symbols.get,
            cond = symbols.has,
          },
        },
        lualine_x = {
          { get_lsps, color = { fg = '#c4a7e7' }, padding = 2 },
          { 'fileformat', padding = { right = 2, left = 1.75 } },
          { 'encoding' },
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
      winbar = winbar_config,
      inactive_winbar = winbar_config,
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
