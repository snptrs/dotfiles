--#### mini.icons
deps.now(function()
  require('mini.icons').setup {
    extension = {
      -- Add icons for custom extension. This will also be used in
      -- 'file' category for input like 'file.my.ext'.
      ['tmpl'] = { glyph = '', hl = 'MiniIconsAzure' },
      ['fish'] = { glyph = '', hl = 'MiniIconsPurple' },
      ['conf'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['bak'] = { glyph = '', hl = 'MiniIconsOrange' },
    },
  }

  package.preload['nvim-web-devicons'] = function()
    require('mini.icons').mock_nvim_web_devicons()
    return package.loaded['nvim-web-devicons']
  end
end)

--#### mini.notify
deps.now(function()
  local get_icon = function(level)
    local icons = {
      INFO = ' ',
      WARN = ' ',
      ERROR = ' ',
    }
    return icons[level] or icons['INFO']
  end

  local notify_filter = function(notif_arr)
    local filter = function(notif)
      if notif.msg:match 'lua_ls' or notif.msg:match 'vtsls: Analyzing' then
        return false
      end
      -- Keep others
      return true
    end
    notif_arr = vim.tbl_filter(filter, notif_arr)
    ---@diagnostic disable-next-line: undefined-global
    return MiniNotify.default_sort(notif_arr)
  end
  require('mini.notify').setup {
    lsp_progress = {
      enable = true,
    },
    content = {
      format = function(notification)
        return string.format(' %s | %s', get_icon(notification.level), notification.msg)
      end,
      sort = notify_filter,
    },
  }

  local opts = {
    ERROR = {
      duration = 3000,
    },
  }
  vim.notify = require('mini.notify').make_notify(opts)

  vim.keymap.set('n', '<leader>nh', function()
    MiniNotify.show_history()
  end, { desc = 'Notification history' })

  vim.keymap.set('n', '<leader>nc', function()
    MiniNotify.clear()
  end, { desc = 'Clear notifications' })
end)

--#### mini.diff
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

--#### mini.git
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

--#### mini.statusline
deps.later(function()
  local active_content = function()
    local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 999 }
    local git = MiniStatusline.section_git { trunc_width = 40 }
    local diff = MiniStatusline.section_diff { trunc_width = 75 }
    local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
    local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
    local search_count = MiniStatusline.section_searchcount { trunc_width = 75 }

    local filename = vim.fn.expand '%:t'
    if filename ~= '' then
      local devicons = require 'nvim-web-devicons'
      local icon = devicons.get_icon(filename)
      filename = (icon and icon .. ' ' or '') .. filename
    end

    local macro = vim.g.macro_recording
    local formatting_disabled = vim.g.disable_autoformat and '󰉥'
    local diff_overlay = (MiniDiff.get_buf_data(0) and MiniDiff.get_buf_data(0).overlay) and '' or nil

    return MiniStatusline.combine_groups {
      { hl = mode_hl, strings = { mode } },
      { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
      '%<', -- Mark general truncate point
      { hl = 'MiniStatuslineFilename', strings = { filename } },
      '%=', -- End left alignment
      { hl = 'MiniStatuslineFileinfo', strings = { lsp } },
      { hl = mode_hl, strings = { search_count } },
      { hl = 'MiniStatuslineModeVisual', strings = { macro, diff_overlay, formatting_disabled } },
    }
  end

  require('mini.statusline').setup { content = { active = active_content } }

  vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
    pattern = '*',
    callback = function()
      local recording_reg = vim.fn.reg_recording()
      if recording_reg ~= '' then
        vim.g.macro_recording = 'Recording @' .. recording_reg
      else
        vim.g.macro_recording = nil
      end
      vim.cmd 'redrawstatus'
    end,
    desc = 'Update statusline macro indicator',
  })
end)

--#### mini.sessions
deps.now(function()
  local cwd = vim.fn.getcwd()
  local project_name = cwd:match '^.+/(.+)$'

  -- close bad buffers (neo-tree, trouble, etc) to avoid saving them in the session
  -- otherwise, loading the session would open them with the wrong size
  local close_bad_buffers = function()
    local buffer_numbers = vim.api.nvim_list_bufs()
    for _, buffer_number in pairs(buffer_numbers) do
      local buffer_type = vim.api.nvim_buf_get_option(buffer_number, 'buftype')
      local buffer_file_type = vim.api.nvim_buf_get_option(buffer_number, 'filetype')

      if buffer_type == 'nofile' or buffer_file_type == 'norg' then
        vim.api.nvim_buf_delete(buffer_number, { force = true })
      end
    end
  end

  local count_open_file_buffers = function()
    local count = 0
    for _, buffer_number in pairs(vim.api.nvim_list_bufs()) do
      local buffer_name = vim.api.nvim_buf_get_name(buffer_number)
      local buffer_file_type = vim.api.nvim_buf_get_option(buffer_number, 'filetype')

      if buffer_name ~= '' and buffer_file_type ~= 'norg' then
        count = count + 1
      end
    end
    return count
  end

  local minisessions = require 'mini.sessions'
  minisessions.setup {
    autoread = false,
    autowrite = false,
    file = '',
    force = { read = false, write = true, delete = false },
    hooks = {
      pre = { read = nil, write = close_bad_buffers, delete = nil },
      post = { read = nil, write = nil, delete = nil },
    },
    verbose = { read = false, write = true, delete = true },
  }

  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
      local number_of_open_buffers = count_open_file_buffers()
      if number_of_open_buffers > 0 then
        minisessions.write(project_name)
      end
    end,
  })

  vim.keymap.set('n', '<leader>sl', function()
    MiniSessions.select()
  end, { desc = 'List sessions' })
  vim.keymap.set('n', '<leader>ss', function()
    MiniSessions.read(project_name)
  end, { desc = 'Load current project session' })
end)

--#### mini.extra
deps.later(function()
  require('mini.extra').setup()
end)

--#### mini.ai
deps.later(function()
  local gen_spec = require('mini.ai').gen_spec
  local gen_ai_spec = require('mini.extra').gen_ai_spec
  require('mini.ai').setup {
    n_lines = 500,
    custom_textobjects = {
      o = gen_spec.treesitter { -- code block
        a = { '@block.outer', '@conditional.outer', '@loop.outer' },
        i = { '@block.inner', '@conditional.inner', '@loop.inner' },
      },
      k = gen_spec.treesitter {
        i = '@assignment.lhs',
        a = '@assignment.lhs',
      },
      f = gen_spec.treesitter { a = '@function.outer', i = '@function.inner' }, -- function
      c = gen_spec.treesitter { a = '@class.outer', i = '@class.inner' }, -- class
      t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
      e = { -- Word with case
        { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
        '^().*()$',
      },
      g = gen_ai_spec.buffer(),
      D = gen_ai_spec.diagnostic(),
      i = gen_ai_spec.indent(),
      L = gen_ai_spec.line(),
      N = gen_ai_spec.number(),
    },
  }
end)

--#### mini.align
deps.later(function()
  require('mini.align').setup()
end)

--#### mini.bracketed
deps.later(function()
  require('mini.bracketed').setup()
  local put_keys = {
    { lhs = 'p', rhs = 'p', desc = 'Put after' },
    { lhs = 'P', rhs = 'P', desc = 'Put before' },
    { lhs = ']p', rhs = ':pu<CR>', desc = 'Put after linewise' },
    { lhs = '[p', rhs = ':pu!<CR>', desc = 'Put before linewise' },
  }

  for _, mapping in ipairs(put_keys) do
    local rhs = 'v:lua.MiniBracketed.register_put_region("' .. mapping.rhs .. '")'
    vim.keymap.set({ 'n', 'x' }, mapping.lhs, rhs, { expr = true, desc = mapping.desc })
  end
end)

--#### mini.comment
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

--#### mini.files
deps.later(function()
  require('mini.files').setup {
    windows = {
      preview = true,
      width_preview = 60,
    },
    options = {
      use_as_default_explorer = true,
      permanent_delete = true,
    },
    mappings = {
      go_in_plus = '<Return>',
    },
  }

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesActionDelete',
    callback = function(args)
      local fname = args.data.from
      local bufnr = vim.fn.bufnr(fname)
      if bufnr > 0 then
        vim.api.nvim_buf_delete(bufnr, { force = true })
        vim.notify('Buffer closed for deleted file', vim.log.levels.INFO, { title = 'Buffer deleted' })
      end
    end,
  })
end)

--#### mini.indentscope
deps.later(function()
  require('mini.indentscope').setup {
    symbol = '▏',
    options = {
      try_as_border = true,
      indent_at_cursor = true,
    },
  }

  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Disable indentscope for certain filetypes',
    pattern = {
      'help',
      'Trouble',
      'trouble',
      'lazy',
      'mason',
      'notify',
    },
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })
end)

--#### mini.operators
deps.later(function()
  require('mini.operators').setup {
    replace = {
      prefix = 'gR',
      reindent_linewise = true,
    },
  }
end)

--#### mini.pairs
deps.later(function()
  require('mini.pairs').setup {
    mappings = {
      ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\][%s\\n(){}%[%]]' },
      ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\][%s\\n(){}%[%]]' },
      ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\][%s\\n(){}%[%]]' },
      ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^`\\].', register = { cr = false } },
    },
  }
end)

--#### mini.surround
deps.later(function()
  vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
  require('mini.surround').setup {}
end)

--#### mini.misc
deps.later(function()
  require('mini.misc').setup()
  require('mini.misc').setup_restore_cursor()
end)

--#### mini.hipatterns
deps.later(function()
  local hipatterns = require 'mini.hipatterns'

  -- Returns hex color group for matching short hex color.
  ---@param match string
  ---@return string
  local hex_color_short = function(_, match)
    local style = 'bg' -- 'fg' or 'bg', for extmark_opts_inline use 'fg'
    local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
    local hex = string.format('#%s%s%s%s%s%s', r, r, g, g, b, b)
    return hipatterns.compute_hex_color_group(hex, style)
  end

  -- Returns hex color group for matching rgb() color.
  ---@param match string
  ---@return string
  local rgb_color = function(_, match)
    local style = 'bg' -- 'fg' or 'bg', for extmark_opts_inline use 'fg'
    local red, green, blue = match:match 'rgb%((%d+), ?(%d+), ?(%d+)%)'
    local hex = string.format('#%02x%02x%02x', red, green, blue)
    return hipatterns.compute_hex_color_group(hex, style)
  end

  -- Returns hex color group for matching rgba() color
  ---@param match string
  ---@return string|false
  local rgba_color = function(_, match)
    local style = 'bg' -- 'fg' or 'bg', for extmark_opts_inline use 'fg'
    local red, green, blue, alpha = match:match 'rgba%((%d+), ?(%d+), ?(%d+), ?(%d*%.?%d*)%)'
    alpha = tonumber(alpha)
    if alpha == nil or alpha < 0 or alpha > 1 then
      return false
    end
    local hex = string.format('#%02x%02x%02x', red * alpha, green * alpha, blue * alpha)
    return hipatterns.compute_hex_color_group(hex, style)
  end

  require('mini.hipatterns').setup {
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
      hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
      todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
      note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

      section_header = { pattern = '^--()####%s.+()$', group = 'MiniHipatternsFixme' },

      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
      -- `#rgb`
      hex_color_short = { pattern = '#%x%x%x%f[%X]', group = hex_color_short },
      -- `rgb(255, 255, 255)`
      rgb_color = { pattern = 'rgb%(%d+, ?%d+, ?%d+%)', group = rgb_color },
      -- `rgba(255, 255, 255, 0.5)`
      rgba_color = {
        pattern = 'rgba%(%d+, ?%d+, ?%d+, ?%d*%.?%d*%)',
        group = rgba_color,
      },
    },
  }
end)

--#### mini.splitjoin
deps.later(function()
  require('mini.splitjoin').setup()
end)

--#### mini.jump2d
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

--#### mini.jump
deps.later(function()
  require('mini.jump').setup()
end)

--#### mini.move
deps.later(function()
  require('mini.move').setup()
end)

--#### mini.cursorword
-- deps.later(function()
--   require('mini.cursorword').setup()
-- end)

--#### mini.clue
deps.later(function()
  local miniclue = require 'mini.clue'
  miniclue.setup {
    window = {
      delay = 750,
      config = {
        width = 'auto',
      },
    },

    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'x', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },

      { mode = 'n', keys = ']' },
      { mode = 'n', keys = '[' },
    },

    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      { mode = 'n', keys = '<Leader>a', desc = '+Aider' },
      { mode = 'n', keys = '<Leader>s', desc = '+Sessions' },
      { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<Leader>c', desc = '+Code' },
      { mode = 'n', keys = '<Leader>f', desc = '+Find' },
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>gd', desc = '+Diff' },
      { mode = 'n', keys = '<Leader>n', desc = '+Notifications' },
      { mode = 'n', keys = '<Leader>t', desc = '+Trouble' },
      { mode = 'n', keys = '<Leader>u', desc = '+Toggle' },
      { mode = 'n', keys = '<Leader>y', desc = '+Yank' },
    },
  }
end)

--#### Bufremove
deps.later(function()
  require('mini.bufremove').setup()

  vim.keymap.set('n', '<leader>bd', function()
    MiniBufremove.delete()
  end, { desc = 'Close buffer' })

  vim.keymap.set('n', '<leader>bD', '<cmd>%bd|e#|bd#<cr>', { desc = 'Close all buffers' })
end)

--#### Pick
deps.later(function()
  local pick_config = require 'deps.config.mini-pick'
  pick_config.setup()
  -- require('mini.pick').setup()
  for _, keymap in ipairs(pick_config.keys) do
    vim.keymap.set('n', keymap[1], keymap[2], { desc = keymap.desc })
  end
end)

--#### Visits
deps.now(function()
  require('mini.visits').setup()

  local map_vis = function(keys, call, desc)
    local rhs = '<Cmd>lua MiniVisits.' .. call .. '<CR>'
    vim.keymap.set('n', '<Leader>' .. keys, rhs, { desc = desc })
  end

  map_vis('vv', 'add_label()', 'Add label')
  map_vis('vV', 'remove_label()', 'Remove label')
  map_vis('v,', 'select_label()', 'Select label (cwd)')
  map_vis('vcc', 'add_label("core")', 'Add to core')
  map_vis('vcC', 'remove_label("core")', 'Remove from core')
  map_vis('vc,', 'select_path(nil, { filter = "core" })', 'Select core (cwd)')
end)
