return {
  setup = function()
    require('mini.icons').setup {
      extension = {
        -- Add icons for custom extension. This will also be used in
        -- 'file' category for input like 'file.my.ext'.
        ['tmpl'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['fish'] = { glyph = '', hl = 'MiniIconsPurple' },
        ['conf'] = { glyph = '', hl = 'MiniIconsGrey' },
        ['bak'] = { glyph = '', hl = 'MiniIconsOrange' },
      },
    }

    package.preload['nvim-web-devicons'] = function()
      require('mini.icons').mock_nvim_web_devicons()
      return package.loaded['nvim-web-devicons']
    end
  end,
}
