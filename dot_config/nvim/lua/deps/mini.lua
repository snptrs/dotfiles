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
  local conf = require 'deps.config.mini-statusline'
  require('mini.statusline').setup { content = { active = conf.active_content } }
  conf.autocmds()
end)

deps.now(function()
  require('deps.config.mini-sessions').config()
end)

deps.now(function()
  require('mini.diff').setup()
  vim.keymap.set('n', '<leader>go', function()
    MiniDiff.toggle_overlay(0)
  end, { desc = 'Show mini.diff overlay' })
end)

deps.now(function()
  require('mini.git').setup()
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