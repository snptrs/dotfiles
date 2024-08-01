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

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'rose-pine',
        component_separators = '|',
        section_separators = '',
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
        lualine_x = { 'filetype' },
        lualine_y = { 'hostname' },
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
