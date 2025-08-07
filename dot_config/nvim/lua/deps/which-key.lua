deps.now(function()
  deps.add { source = 'folke/which-key.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('which-key').setup {
    ---@type false | "classic" | "modern" | "helix"
    preset = 'helix',
    -- Delay before showing the popup. Can be a number or a function that returns a number.
    ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
    delay = function(ctx)
      return ctx.plugin and 150 or 300
    end,
    mode = { 'n', 'v' },
    spec = {
      { '<leader>b', group = 'Buffers' },
      { '<leader>c', group = 'Code' },
      { '<leader>d', group = 'Document' },
      { '<leader>g', group = 'Git' },
      { '<leader>gd', group = 'Diff' },
      { '<leader>f', group = 'Find' },
      { '<leader>h', group = 'More git' },
      { '<leader>n', group = 'Notifications' },
      { '<leader>s', group = 'Session' },
      { '<leader>w', group = 'Workspace' },
      { '<leader>t', group = 'Trouble' },
      { '<leader>ga', group = 'Git (cursor actions)' },
      { '<leader>u', desc = 'Toggle' },
      { '[', group = 'prev' },
      { ']', group = 'next' },
      { 'g', group = 'goto' },
      { 'gz', group = 'surround' },
      { 'gd', icon = ' ' },
      { 'gr', icon = ' ' },
    },
  }

  local mini_ai = require 'deps.config.mini-ai'
  mini_ai.func()
end)
