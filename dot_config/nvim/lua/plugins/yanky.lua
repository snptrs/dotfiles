return {
  'gbprod/yanky.nvim',
  enabled = false,
  dependencies = {
    { 'kkharji/sqlite.lua' },
  },
  opts = {
    ring = {
      storage = 'sqlite',
      update_register_on_cycle = true,
    },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 250,
    },
    preserve_cursor_position = {
      enabled = true,
    },
    textobj = {
      enabled = true,
    },
  },
  keys = {
    { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
    { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
    { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
    { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Select previous entry through yank history' },
    { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Select next entry through yank history' },
    { ']p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
    { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
    { ']P', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
    { '[P', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
    { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and indent right' },
    { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and indent left' },
    { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put before and indent right' },
    { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put before and indent left' },
    { '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put after applying a filter' },
    { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put before applying a filter' },
    {
      'lp',
      function()
        require('yanky.textobj').last_put()
      end,
      mode = { 'o', 'x' },
      desc = 'Last put textobject',
    },
  },
}
