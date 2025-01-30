deps.now(function()
  local conf = require 'deps.config.mini-icons'
  require('mini.icons').setup(conf.opts)

  package.preload['nvim-web-devicons'] = function()
    require('mini.icons').mock_nvim_web_devicons()
    return package.loaded['nvim-web-devicons']
  end
end)

deps.now(function()
  require('deps.config.mini-notify').config()
end)

deps.now(function()
  require('deps.config.mini-pick').setup()
end)

deps.now(function()
  require('mini.diff').setup {
    options = {
      wrap_goto = true,
    },
  }
  vim.keymap.set('n', '<leader>go', function()
    MiniDiff.toggle_overlay(0)
  end, { desc = 'Show mini.diff overlay' })
end)

deps.now(function()
  require('mini.git').setup()
  local git_helpers = require 'helpers.git-helpers'
  --stylua: ignore start
  vim.keymap.set('n', '<Leader>gc', '<cmd>Git commit -v<cr>', {desc = 'Commit'})
  vim.keymap.set('n', '<Leader>gdd', '<cmd>Git diff<cr>', {desc = 'Git diff (basic)'})
  vim.keymap.set('n', '<Leader>gas', function() MiniGit.show_at_cursor() end, { desc = 'Show git data' })
  vim.keymap.set('n', '<Leader>gae', git_helpers.edit_path_at_cursor, { desc = 'Edit path at cursor' })
  --stylua: ignore end
end)

deps.now(function()
  local conf = require 'deps.config.mini-statusline'
  require('mini.statusline').setup { content = { active = conf.active_content } }
  conf.autocmds()
end)

deps.now(function()
  require('deps.config.mini-sessions').config()
end)

deps.later(function()
  require('mini.extra').setup()
end)

deps.later(function()
  local conf = require 'deps.config.mini-ai'
  require('mini.ai').setup(conf.opts)
end)

deps.later(function()
  require('mini.align').setup()
end)

deps.later(function()
  local conf = require 'deps.config.mini-bracketed'
  require('mini.bracketed').setup()
  conf.func()
end)

deps.later(function()
  deps.add { source = 'JoosepAlviste/nvim-ts-context-commentstring' }
  require('ts_context_commentstring').setup {
    enable_autocmd = false,
  }

  require('mini.comment').setup {
    options = {
      custom_commentstring = function()
        return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
      end,
    },
  }
end)

deps.later(function()
  require('mini.files').setup {
    windows = {
      preview = true,
      width_preview = 60,
    },
    options = {
      use_as_default_explorer = false,
    },
  }
end)

-- deps.later(function()
--   local conf = require 'deps.config.mini-indentscope'
--   require('mini.indentscope').setup(conf.opts)
--   conf.autocmds()
-- end)

deps.later(function()
  require('mini.operators').setup {
    replace = {
      prefix = 'gR',
      reindent_linewise = true,
    },
  }
end)

deps.later(function()
  require('mini.pairs').setup {
    mappings = {
      ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^`\\].', register = { cr = false } },
      -- ['('] = { action = 'closeopen', pair = '()', neigh_pattern = '[^\\S]', register = { cr = false } },
    },
  }
end)

deps.later(function()
  local conf = require 'deps.config.mini-surround'
  require('mini.surround').setup(conf.opts)
end)

deps.later(function()
  require('mini.misc').setup()
  require('mini.misc').setup_restore_cursor()
  require('mini.misc').setup_auto_root()
end)

deps.later(function()
  require('deps.config.mini-hipatterns').conf()
end)

deps.later(function()
  require('mini.splitjoin').setup()
end)

deps.later(function()
  local jump2d = require 'mini.jump2d'
  local jump_word_start = jump2d.builtin_opts.word_start
  require('mini.jump2d').setup {
    spotter = jump_word_start.spotter,
    view = {
      dim = true,
    },
  }
  vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { fg = 'Orange' })
  vim.api.nvim_set_hl(0, 'MiniJump2dSpotUnique', { fg = 'Orange' })
  vim.api.nvim_set_hl(0, 'MiniJump2dSpotAhead', { fg = 'Orange' })
end)

deps.later(function()
  require('mini.jump').setup()
end)

deps.later(function()
  require('mini.move').setup()
end)

-- deps.later(function()
--   local miniclue = require 'mini.clue'
--   miniclue.setup {
--     triggers = {
--       -- Leader triggers
--       { mode = 'n', keys = '<Leader>' },
--       { mode = 'x', keys = '<Leader>' },
--
--       -- Built-in completion
--       { mode = 'i', keys = '<C-x>' },
--
--       -- `g` key
--       { mode = 'n', keys = 'g' },
--       { mode = 'x', keys = 'g' },
--
--       -- Marks
--       { mode = 'n', keys = "'" },
--       { mode = 'n', keys = '`' },
--       { mode = 'x', keys = "'" },
--       { mode = 'x', keys = '`' },
--
--       -- Registers
--       { mode = 'n', keys = '"' },
--       { mode = 'x', keys = '"' },
--       { mode = 'i', keys = '<C-r>' },
--       { mode = 'c', keys = '<C-r>' },
--
--       -- Window commands
--       { mode = 'n', keys = '<C-w>' },
--
--       -- `z` key
--       { mode = 'n', keys = 'z' },
--       { mode = 'x', keys = 'z' },
--     },
--
--     clues = {
--       miniclue.gen_clues.builtin_completion(),
--       miniclue.gen_clues.g(),
--       miniclue.gen_clues.marks(),
--       miniclue.gen_clues.registers(),
--       miniclue.gen_clues.windows(),
--       miniclue.gen_clues.z(),
--       { mode = 'n', keys = '<Leader>s', desc = '+Sessions' },
--       { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
--       { mode = 'n', keys = '<Leader>c', desc = '+Code' },
--       { mode = 'n', keys = '<Leader>cc', desc = '+CodeCompanion' },
--     },
--   }
-- end)
