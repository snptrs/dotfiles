return {
  'folke/noice.nvim',
  enabled = true,
  event = 'VeryLazy',
  -- stylua: ignore
  keys = {
    { '<leader>n',  '',                                                                            desc = '+noice' },
    { '<leader>nl', function() require('noice').cmd('last') end,                                   desc = 'Noice Last Message' },
    { '<leader>nh', function() require('noice').cmd('history') end,                                desc = 'Noice History' },
    { '<leader>na', function() require('noice').cmd('all') end,                                    desc = 'Noice All' },
    { '<leader>nt', function() require('noice').cmd('pick') end,                                   desc = 'Noice Picker (Telescope/FzfLua)' },
    { '<C-f>',      function() if not require('noice.lsp').scroll(4) then return '<C-f>' end end,  silent = true,                           expr = true, desc = 'Scroll Forward',  mode = { 'i', 'n', 's' } },
    { '<C-b>',      function() if not require('noice.lsp').scroll(-4) then return '<C-b>' end end, silent = true,                           expr = true, desc = 'Scroll Backward', mode = { 'i', 'n', 's' } },
  },
  opts = {
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
      -- documentation = {
      --   opts = { -- Move docs and signature help up so they don't overlap CMP popup
      --     anchor = 'SW',
      --     position = {
      --       row = 1,
      --     },
      --   },
      -- },
      hover = {
        silent = true,
      },
      signature = {
        enabled = false,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true,         -- use a classic bottom cmdline for search
      command_palette = true,       -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true,            -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true,        -- add a border to hover docs and signature help
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'written',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'No information available',
        },

        opts = { skip = true },
      },
      {
        filter = { find = 'nvim-treesitter' },
        opts = { skip = true },
      },
      {
        filter = { find = 'will return nil instead of raising' },
        opts = { skip = true },
      },
      {
        view = 'notify',
        filter = {
          event = 'msg_showmode',
        },
      },
      {
        filter = {
          event = 'msg_show',
          any = {
            { find = '%d+L, %d+B' },
            { find = '; after #%d+' },
            { find = '; before #%d+' },
            { find = '%d fewer lines' },
            { find = '%d more lines' },
            { find = '%d lines yanked' },
            { kind = 'emsg',           find = 'E37' },
          },
        },
        opts = { skip = true },
      },
      {
        view = 'split',
        filter = { event = 'msg_show', min_height = 20 },
      },
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- {
    --   'rcarriga/nvim-notify',
    --   opts = {
    --     render = 'wrapped-compact',
    --     stages = 'fade_in_slide_out',
    --     timeout = 1500,
    --     minimum_width = 25,
    --     max_width = 50,
    --     fps = 60,
    --   },
    -- },
  },
}
