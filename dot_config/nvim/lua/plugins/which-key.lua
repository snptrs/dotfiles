return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    ---@type false | "classic" | "modern" | "helix"
    preset = 'classic',
    -- Delay before showing the popup. Can be a number or a function that returns a number.
    ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
    delay = function(ctx)
      return ctx.plugin and 0 or 150
    end,
    mode = { 'n', 'v' },
    spec = {
      { '<leader>c', group = 'Code' },
      { '<leader>d', group = 'Document' },
      { '<leader>g', group = 'Git' },
      { '<leader>gd', group = 'Diff' },
      { '<leader>f', group = 'Find (Telescope)' },
      { '<leader>h', group = 'More git' },
      { '<leader>s', group = 'Session' },
      { '<leader>w', group = 'Workspace' },
      { '<leader>x', group = 'Trouble' },
      { '<leader>,', desc = 'Arrow' },
      { '[', group = 'prev' },
      { ']', group = 'next' },
      { 'g', group = 'goto' },
      { 'gz', group = 'surround' },
      { 'z', group = 'fold' },
      { '<leader>t', group = 'Tabs' },
      { '<leader>tn', '<cmd>tabn<cr>', desc = 'Next tab' },
      { '<leader>tp', '<cmd>tabp<cr>', desc = 'Previous tab' },
      { '<leader>tc', '<cmd>tabc<cr>', desc = 'Close tab' },
      { '<leader>te', '<cmd>tabe<cr>', desc = 'New tab' },
      {
        '<leader>dh',
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end,
        desc = 'Toggle inlay hints',
      },
    },
  },
}
