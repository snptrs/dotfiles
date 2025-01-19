deps.now(function()
  deps.add {
    source = 'folke/noice.nvim',
    depends = { 'MunifTanjim/nui.nvim' },
  }
  ---@diagnostic disable-next-line: missing-fields
  require('noice').setup {
    notify = {
      enabled = false,
    },
    messages = {
      enabled = false,
    },
    lsp = {
      progress = {
        enabled = false,
      },
      message = {
        enabled = true,
      },
      hover = {
        silent = true,
      },
      signature = {
        enabled = false,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    -- routes = {
    --   {
    --     filter = {
    --       event = 'msg_show',
    --       kind = '',
    --       find = 'written',
    --     },
    --     opts = { skip = true },
    --   },
    --   {
    --     filter = {
    --       event = 'msg_show',
    --       kind = '',
    --       find = 'No information available',
    --     },
    --
    --     opts = { skip = true },
    --   },
    --   {
    --     filter = { find = 'nvim-treesitter' },
    --     opts = { skip = true },
    --   },
    --   {
    --     filter = { find = 'will return nil instead of raising' },
    --     opts = { skip = true },
    --   },
    --   {
    --     view = 'notify',
    --     filter = {
    --       event = 'msg_showmode',
    --     },
    --   },
    --   {
    --     filter = {
    --       event = 'msg_show',
    --       any = {
    --         { find = '%d+L, %d+B' },
    --         { find = '; after #%d+' },
    --         { find = '; before #%d+' },
    --         { find = '%d fewer lines' },
    --         { find = '%d more lines' },
    --         { find = '%d lines yanked' },
    --         { kind = 'emsg', find = 'E37' },
    --       },
    --     },
    --     opts = { skip = true },
    --   },
    --   {
    --     view = 'split',
    --     filter = { event = 'msg_show', min_height = 20 },
    --   },
    -- },
  }

  -- Noice keymaps
  vim.keymap.set('n', '<leader>n', '', { desc = '+noice' })
  vim.keymap.set('n', '<leader>nl', function()
    require('noice').cmd 'last'
  end, { desc = 'Noice Last Message' })
  vim.keymap.set('n', '<leader>nh', function()
    require('noice').cmd 'history'
  end, { desc = 'Noice History' })
  vim.keymap.set('n', '<leader>na', function()
    require('noice').cmd 'all'
  end, { desc = 'Noice All' })
  vim.keymap.set('n', '<leader>nt', function()
    require('noice').cmd 'pick'
  end, { desc = 'Noice Picker (Telescope/FzfLua)' })

  -- Scroll keymaps for multiple modes
  local scroll_opts = { silent = true, expr = true }
  for _, mode in ipairs { 'i', 'n', 's' } do
    vim.keymap.set(mode, '<C-f>', function()
      if not require('noice.lsp').scroll(4) then
        return '<C-f>'
      end
    end, vim.tbl_extend('force', scroll_opts, { desc = 'Scroll Forward' }))

    vim.keymap.set(mode, '<C-b>', function()
      if not require('noice.lsp').scroll(-4) then
        return '<C-b>'
      end
    end, vim.tbl_extend('force', scroll_opts, { desc = 'Scroll Backward' }))
  end
end)
