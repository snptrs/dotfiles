deps.now(function()
  deps.add {
    source = 'folke/snacks.nvim',
    -- depends = { 'folke/trouble.nvim' },
  }

  require('snacks').setup {
    bigfile = {},
    image = { doc = { max_width = 40, inline = false } },
    input = {},
    lazygit = {},
    terminal = {},
    picker = {
      formatters = {
        file = {
          filename_first = true,
          truncate = 70,
        },
      },
    },
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
  vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.open() end, { desc = 'Open lazygit' })
  vim.keymap.set({'n', 't'}, '<c-w>/', function() Snacks.terminal.toggle() end, { desc = 'Toggle terminal'})


  vim.keymap.set('n', '<leader><space>',
    function()
      ---@diagnostic disable-next-line: missing-fields
      Snacks.picker.buffers({layout = {preset = "select"}})
    end,
    { desc = 'Open buffers' })
  vim.keymap.set('n', '<leader>fg', function() Snacks.picker.grep() end, { desc = 'Grep' })
  vim.keymap.set('n', '<leader>f:', function() Snacks.picker.command_history() end, { desc = 'Command History' })
  vim.keymap.set('n', '<leader>ff',
    function()
      ---@diagnostic disable-next-line: missing-fields
      Snacks.picker.files {
        matcher = {
          cwd_bonus = true, -- boost cwd matches
          frecency = true, -- use frecency boosting
          sort_empty = true, -- sort even when the filter is empty
        },
        hidden = true,
        layout = {
          preview = false,
          layout = {
            width = 0.6,
            min_width = 120,
            height = 0.6,
          },
        },
      }
    end,
    { desc = 'Find Files' })
  vim.keymap.set('n', '<leader>fR', function() Snacks.picker.recent() end, { desc = 'Recent' })
  vim.keymap.set('n', '<leader>fr', function() Snacks.picker.resume() end, { desc = 'Resume' })

  -- Git mappings
  vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git Status' })

  -- Grep mappings
  vim.keymap.set('n', '<leader>fb', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
  vim.keymap.set('n', '<leader>fB', function() Snacks.picker.grep_buffers() end, { desc = 'Grep Open Buffers' })
  vim.keymap.set('n', '<leader>fw', function() Snacks.picker.grep_word() end, { desc = 'Visual selection or word' })

  -- Search mappings
  vim.keymap.set('n', '<leader>fa', function() Snacks.picker.autocmds() end, { desc = 'Autocmds' })
  vim.keymap.set('n', '<leader>fC', function() Snacks.picker.commands() end, { desc = 'Commands' })
  vim.keymap.set('n', '<leader>fD', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
  vim.keymap.set('n', '<leader>fd', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Diagnostics (buffer)' })
  vim.keymap.set('n', '<leader>fh', function() Snacks.picker.help() end, { desc = 'Help Pages' })
  vim.keymap.set('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
  vim.keymap.set('n', '<leader>fq', function() Snacks.picker.qflist() end, { desc = 'Quickfix List' })
  vim.keymap.set('n', '<leader>fy', function() Snacks.picker.registers() end, { desc = 'Registers' })

  -- LSP mappings
  vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
  vim.keymap.set('n', 'grr', function() Snacks.picker.lsp_references() end, { desc = 'References', nowait = true })
  vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
  vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
  -- stylua: ignore end

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
      vim.keymap.set('n', '<leader>uw', function()
        vim.b.minicursorword_disable = not (vim.b.minicursorword_disable or false)
        local new_state = vim.b.minicursorword_disable
        vim.notify('Cursor word ' .. (new_state and 'disabled' or 'enabled'), new_state and vim.log.levels.WARN or vim.log.levels.INFO)
      end, { desc = 'Toggle minicursorword' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesActionRename',
    callback = function(event)
      Snacks.rename.on_rename_file(event.data.from, event.data.to)
    end,
  })
end)
