return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' }, -- to disable, comment this out
  cmd = { 'ConformInfo' },
  notify_on_error = true,
  keys = {
    {
      -- Customize or remove this keymap to your liking
      '<leader>df',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      svelte = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      scss = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'rustywind' },
      json = { 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'prettierd', 'prettier', stop_after_first = true },
      markdown = { 'prettierd', 'prettier', stop_after_first = true },
      graphql = { 'prettierd', 'prettier', stop_after_first = true },
      lua = { 'stylua' },
      python = { 'isort', 'ruff' },
      php = { 'pint', 'phpcbf' },
      toml = { 'taplo' },
    },
    format_on_save = function(bufnr)
      if vim.bo[bufnr].filetype == 'php' then
        return
      end
      return { timeout_ms = 1000, lsp_fallback = true }
    end,
    format_after_save = function(bufnr)
      if not vim.bo[bufnr].filetype == 'php' then
        return
      end
      return { lsp_fallback = true }
    end,
    -- Customize formatters
    formatters = {
      phpcbf = {
        prepend_args = { '--standard=PSR12', '--extensions=php' },
      },
      pint = {
        prepend_args = { '--preset', 'psr12' },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
