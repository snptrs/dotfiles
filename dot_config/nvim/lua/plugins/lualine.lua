return {
  'nvim-lualine/lualine.nvim',
  event = 'ColorScheme',
  opts = {
    options = {
      icons_enabled = true,
      theme = 'rose-pine',
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_a = {
        'mode',
        function()
          local reg = vim.fn.reg_recording()
          if reg == '' then
            return ''
          end -- not recording
          return 'recording @' .. reg
        end,
      },
      lualine_b = {
        'branch',
        'diff',
        'diagnostics',
      },
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
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
  },
}
