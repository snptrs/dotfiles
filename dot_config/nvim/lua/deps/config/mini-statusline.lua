return {
  active_content = function()
    local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 999 }
    local git = MiniStatusline.section_git { trunc_width = 40 }
    local diff = MiniStatusline.section_diff { trunc_width = 75 }
    local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
    local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
    local search_count = MiniStatusline.section_searchcount { trunc_width = 75 }

    local macro = vim.g.macro_recording
    local diff_overlay = (MiniDiff.get_buf_data(0) and MiniDiff.get_buf_data(0).overlay) and '' or nil

    -- This version will only show if the current file is tagged
    -- local grapple = package.loaded['grapple'] and require('grapple').exists() and require('grapple').statusline()
    local grapple = package.loaded['grapple'] and require('grapple').statusline()

    return MiniStatusline.combine_groups {
      { hl = mode_hl, strings = { mode } },
      { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
      '%<', -- Mark general truncate point
      { hl = 'MiniStatuslineFilename', strings = { '%f' } },
      '%=', -- End left alignment
      { hl = 'MiniStatuslineFileinfo', strings = { lsp, grapple } },
      { hl = mode_hl, strings = { search_count, macro, diff_overlay } },
    }
  end,

  autocmds = function()
    -- Autocmd to track the start of macro recording
    vim.api.nvim_create_autocmd('RecordingEnter', {
      pattern = '*',
      callback = function()
        vim.g.macro_recording = 'Recording @' .. vim.fn.reg_recording()
        vim.cmd 'redrawstatus'
      end,
    })

    -- Autocmd to track the end of macro recording
    vim.api.nvim_create_autocmd('RecordingLeave', {
      pattern = '*',
      callback = function()
        vim.g.macro_recording = ''
        vim.cmd 'redrawstatus'
      end,
    })
  end,
}
