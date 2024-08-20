return {
  'Wansmer/treesj',
  keys = {
    { 'gJ',  '<cmd>TSJToggle<cr>', desc = "Toggle split/join" },
    { 'gjs', '<cmd>TSJSplit<cr>',  desc = "Split" },
    { 'gjj', '<cmd>TSJJoin<cr>',   desc = "Join" },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  opts = {
    use_default_keymaps = false,
  }
}
