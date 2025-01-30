local opts = require 'deps.config.snacks-opts'
return {
  create = function()
    -- stylua: ignore start
    vim.keymap.set('n', '<leader>z', function() Snacks.zen() end, { desc = 'Toggle Zen Mode' })
    vim.keymap.set('n', '<leader>Z', function() Snacks.zen.zoom() end, { desc = 'Toggle Zoom' })
    vim.keymap.set('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Toggle Scratch Buffer' })
    vim.keymap.set('n', '<leader>S', function() Snacks.scratch.select() end, { desc = 'Select Scratch Buffer' })
    vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
    vim.keymap.set('n', '<leader>cR', function() Snacks.rename.rename_file() end, { desc = 'Rename File' })
    vim.keymap.set('n', '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })
    vim.keymap.set('n', '<leader>gb', function() Snacks.git.blame_line() end, { desc = 'Git Blame Line' })
    vim.keymap.set('n', '<leader>un', function() Snacks.notifier.hide() end, { desc = 'Dismiss All Notifications' })
    vim.keymap.set('n', ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next Reference' })
    vim.keymap.set('n', '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev Reference' })
    vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.open() end, { desc = 'Open lazygit' })

    -- Picker mappings
    -- vim.keymap.set('n', '<leader><space>', function() Snacks.picker.buffers(opts.pickers.buffers) end, { desc = 'Open buffers' })
    -- vim.keymap.set('n', '<leader>fg', function() Snacks.picker.grep() end, { desc = 'Grep' })
    -- vim.keymap.set('n', '<leader>f:', function() Snacks.picker.command_history() end, { desc = 'Command History' })
    -- vim.keymap.set('n', '<leader>ff', function() return Snacks.picker.files(opts.pickers.files) end, { desc = 'Find Files' })
    -- vim.keymap.set('n', '<leader>fR', function() Snacks.picker.recent() end, { desc = 'Recent' })
    -- vim.keymap.set('n', '<leader>fr', function() Snacks.picker.resume() end, { desc = 'Resume' })

    -- Git mappings
    vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git Status' })

    -- Grep mappings
    vim.keymap.set('n', '<leader>fb', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
    vim.keymap.set('n', '<leader>fB', function() Snacks.picker.grep_buffers() end, { desc = 'Grep Open Buffers' })
    vim.keymap.set('n', '<leader>fw', function() Snacks.picker.grep_word() end, { desc = 'Visual selection or word' })

    -- Search mappings
    -- vim.keymap.set('n', '<leader>fa', function() Snacks.picker.autocmds() end, { desc = 'Autocmds' })
    -- vim.keymap.set('n', '<leader>fC', function() Snacks.picker.commands() end, { desc = 'Commands' })
    -- vim.keymap.set('n', '<leader>fd', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
    -- vim.keymap.set('n', '<leader>fh', function() Snacks.picker.help() end, { desc = 'Help Pages' })
    -- vim.keymap.set('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
    -- vim.keymap.set('n', '<leader>fq', function() Snacks.picker.qflist() end, { desc = 'Quickfix List' })

    -- LSP mappings
    vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
    vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = 'References', nowait = true })
    vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
    vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
    -- stylua: ignore end
  end,
}
