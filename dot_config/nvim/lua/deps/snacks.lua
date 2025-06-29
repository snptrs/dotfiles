deps.now(function()
  deps.add {
    source = 'folke/snacks.nvim',
    depends = { 'folke/trouble.nvim' },
  }

  local conf = require 'deps.config.snacks-opts'
  local keys = require 'deps.config.snacks-keys'

  require('snacks').setup {
    bigfile = {},
    image = {},
    indent = { indent = { enabled = true, only_current = true } },
    input = {},
    lazygit = {
      theme = {
        [241] = { fg = 'Special' },
        activeBorderColor = { fg = 'DiagnosticHint', bold = true },
        cherryPickedCommitBgColor = { fg = 'Identifier' },
        cherryPickedCommitFgColor = { fg = 'Function' },
        defaultFgColor = { fg = 'Normal' },
        inactiveBorderColor = { fg = 'FloatBorder' },
        optionsTextColor = { fg = 'Function' },
        searchingActiveBorderColor = { fg = 'MatchParen', bold = true },
        selectedLineBgColor = { bg = 'Visual' }, -- set to `default` to have no background colour
        unstagedChangesColor = { fg = 'DiagnosticError' },
      },
    },

    notifier = conf.notifier.opts,
    picker = conf.picker.opts,
    words = {},
    zen = conf.zen.opts,
    styles = conf.styles.opts,
  }

  keys.create()

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
end)
