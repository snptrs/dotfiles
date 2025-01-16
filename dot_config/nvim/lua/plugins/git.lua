return {
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    opts = {
      {
        disable_diagnostics = true,
        list_opener = 'copen', -- command or function to open the conflicts list
      },
    },
  },
  -- { 'tpope/vim-fugitive' },
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  -- {
  --   'lewis6991/gitsigns.nvim',
  --   event = 'BufEnter',
  --   opts = {
  --     -- See `:help gitsigns.txt`
  --     signs = {
  --       add = { text = '+' },
  --       change = { text = '~' },
  --       delete = { text = '_' },
  --       topdelete = { text = '‾' },
  --       changedelete = { text = '~' },
  --     },
  --     current_line_blame_opts = { virt_text_pos = 'right_align', delay = 250 },
  --     current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  --
  --     on_attach = function(bufnr)
  --       local gitsigns = require 'gitsigns'
  --       local function map(mode, l, r, opts)
  --         opts = opts or {}
  --         opts.buffer = bufnr
  --         vim.keymap.set(mode, l, r, opts)
  --       end
  --
  --       map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage git hunk' })
  --       map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset git hunk' })
  --       map('v', '<leader>hs', function()
  --         gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
  --       end, { desc = 'Stage git hunk' })
  --       map('v', '<leader>hr', function()
  --         gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
  --       end, { desc = 'Reset git hunk' })
  --       map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage all git hunks' })
  --       map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo stage git hunk' })
  --       map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset all git hunks' })
  --       map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview git hunk' })
  --       map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'Preview git hunk inline' })
  --       map('n', '<leader>hb', function()
  --         gitsigns.blame_line { full = true }
  --       end, { desc = 'Blame line' })
  --       map('n', '<leader>ht', gitsigns.toggle_current_line_blame, { desc = 'Toggle current line blame' })
  --       map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff this' })
  --       map('n', '<leader>hD', function()
  --         gitsigns.diffthis '~'
  --       end, { desc = 'Diff this' })
  --       map('n', '<leader>hx', gitsigns.toggle_deleted, { desc = 'Toggle deleted' })
  --
  --       -- don't override the built-in and fugitive keymaps
  --       local gs = package.loaded.gitsigns
  --       vim.keymap.set({ 'n', 'v' }, ']c', function()
  --         if vim.wo.diff then
  --           return ']c'
  --         end
  --         vim.schedule(function()
  --           gs.next_hunk()
  --         end)
  --         return '<Ignore>'
  --       end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
  --       vim.keymap.set({ 'n', 'v' }, '[c', function()
  --         if vim.wo.diff then
  --           return '[c'
  --         end
  --         vim.schedule(function()
  --           gs.prev_hunk()
  --         end)
  --         return '<Ignore>'
  --       end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
  --     end,
  --   },
  -- },
}
