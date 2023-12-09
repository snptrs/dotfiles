return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      on_attach = function(bufnr)
        local api = require 'nvim-tree.api'

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts 'Up')
        vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
      end,

      hijack_unnamed_buffer_when_opening = true,
      actions = {
        open_file = {
          -- resize_window = false,
        },
      },
      view = { relativenumber = true, width = 40 },
      renderer = {
        icons = {
          web_devicons = { folder = { enable = true } },
        },
        -- highlight_opened_files = 'all',
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      git = {
        show_on_open_dirs = false,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
      live_filter = {
        always_show_folders = false,
      },
    }

    vim.api.nvim_create_autocmd({ 'VimEnter' }, {
      callback = function()
        require('nvim-tree.api').tree.toggle { focus = false, find_file = true }
      end,
    })

    -- vim.api.nvim_create_autocmd('QuitPre', {
    --   callback = function()
    --     local invalid_win = {}
    --     local wins = vim.api.nvim_list_wins()
    --     for _, w in ipairs(wins) do
    --       local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
    --       if bufname:match 'NvimTree_' ~= nil then
    --         table.insert(invalid_win, w)
    --       end
    --     end
    --     if #invalid_win == #wins - 1 then
    --       -- Should quit, so we close all invalid windows.
    --       for _, w in ipairs(invalid_win) do
    --         vim.api.nvim_win_close(w, true)
    --       end
    --     end
    --   end,
    -- })
  end,
}
