deps.later(function()
  deps.add {
    source = 'stevearc/quicker.nvim',
  }

  require('quicker').setup {
    highlight = {
      -- Use treesitter highlighting
      treesitter = true,
      -- Use LSP semantic token highlighting
      lsp = false,
      -- Load the referenced buffers to apply more accurate highlights (may be slow)
      load_buffers = true,
    },
    keys = {
      {
        '>',
        function()
          require('quicker').expand { before = 1, after = 1, add_to_existing = true }
        end,
        desc = 'Expand quickfix context',
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse quickfix context',
      },
    },
  }

  vim.keymap.set('n', '<leader>q', function()
    require('quicker').toggle()
  end, {
    desc = 'Toggle quickfix',
  })
  vim.keymap.set('n', '<leader>l', function()
    require('quicker').toggle { loclist = true }
  end, {
    desc = 'Toggle loclist',
  })
end)
