return {
  {
    'numtostr/comment.nvim',
    event = 'VeryLazy',
    dependencies = {
      'joosepalviste/nvim-ts-context-commentstring',
      opts = {
        enable_autocmd = false,
      },
      config = {
        function()
          vim.g.skip_ts_context_commentstring_module = true
        end,
      },
    },
    config = function()
      local prehook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      require('Comment').setup {
        pre_hook = prehook,
      }
    end,
  },
}
