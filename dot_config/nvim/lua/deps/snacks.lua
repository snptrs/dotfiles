deps.now(function()
  deps.add {
    source = 'folke/snacks.nvim',
  }

  require('snacks').setup {
    bigfile = {},
    image = { doc = { max_width = 25, inline = false } },
    input = {},
    lazygit = {},
    terminal = {},
    statuscolumn = {
      folds = {
        open = true,
      },
    },
    words = {},
    zen = {
      enabled = true,
      toggles = {
        dim = false,
        diagnostics = false,
      },
    },
    styles = {
      snacks_image = {
        relative = 'editor',
        col = -1,
      },
      zen = {
        relative = 'editor',
        backdrop = {
          transparent = false,
        },
      },
    },
  }

  -- #### KEYMAPS ####
  -- stylua: ignore start
  vim.keymap.set('n', '<leader>z', function() Snacks.zen() end, { desc = 'Toggle Zen Mode' })
  vim.keymap.set('n', '<leader>Z', function() Snacks.zen.zoom() end, { desc = 'Toggle Zoom' })
  vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
  vim.keymap.set('n', '<leader>dR', function() Snacks.rename.rename_file() end, { desc = 'Rename File' })
  vim.keymap.set('n', '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })
  vim.keymap.set('n', '<leader>gb', function() Snacks.git.blame_line() end, { desc = 'Git Blame Line' })
  vim.keymap.set('n', ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next Reference' })
  vim.keymap.set('n', '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev Reference' })
  vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.open() end, { desc = 'Open Lazygit' })
  vim.keymap.set('n', '<leader>gf', function() Snacks.lazygit.log_file() end, { desc = 'Lazygit file log' })
  vim.keymap.set({'n', 't'}, '<c-w>/', function() Snacks.terminal.toggle() end, { desc = 'Toggle terminal'})

  -- #### AUTOCOMMANDS ####
  vim.api.nvim_create_autocmd('User', {
    pattern = '*',
    callback = function()
      -- Setup some globals for debugging (lazy-loaded)
      _G.dd = function(...)
        Snacks.debug.inspect(...)
      end
      _G.bt = function()
        Snacks.debug.backtrace()
      end
      vim.print = _G.dd -- Override print to use snacks for `:=` command

      -- Create some toggle mappings
      Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
      Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>ur'
      Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
      Snacks.toggle.diagnostics():map '<leader>ud'
      Snacks.toggle.line_number():map '<leader>ul'
      Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
      Snacks.toggle.treesitter():map '<leader>uT'
      Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
      Snacks.toggle.inlay_hints():map '<leader>uh'
      Snacks.toggle.indent():map '<leader>ug'
      Snacks.toggle.dim():map '<leader>uD'
      Snacks.toggle.words():map '<leader>uw'
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesActionRename',
    callback = function(event)
      Snacks.rename.on_rename_file(event.data.from, event.data.to)
    end,
  })
end)
