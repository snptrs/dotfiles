local opts = require 'plugins.snacks.opts'

return {
  general = {
    -- stylua: ignore start
    { '<leader>z', function() Snacks.zen() end, desc = 'Toggle Zen Mode' },
    { '<leader>Z', function() Snacks.zen.zoom() end, desc = 'Toggle Zoom' },
    { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
    { '<leader>S', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
    { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File' },
    { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse', mode = { 'n', 'v' } },
    -- { '<leader>gb', function() Snacks.git.blame_line() end, desc = 'Git Blame Line' },
    -- { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications' },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
    -- stylua: ignore end
  },
  picker = {
    -- stylua: ignore start
    { "<leader><space>", function() Snacks.picker.buffers(opts.pickers.buffers) end, desc = "Buffers" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>ff", function()
      return Snacks.picker.files(opts.pickers.files) end, desc = "Find Files" },
    { "<leader>fR", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume" },
    -- git
    { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    -- Grep
    { "<leader>fb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>fB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { "<leader>fa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>fC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    -- stylua: ignore end
  },
}
