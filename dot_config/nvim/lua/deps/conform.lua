deps.later(function()
  deps.add {
    source = 'stevearc/conform.nvim',
  }

  require('conform').setup {
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
      fish = { 'fish_indent' },
      kdl = { 'kdlfmt' },
      blade = { 'blade-formatter' },
      kotlin = { 'ktfmt' },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      if vim.bo[bufnr].filetype == 'php' then
        return
      end
      return { timeout_ms = 1000, lsp_fallback = true }
    end,
    format_after_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      if not vim.bo[bufnr].filetype == 'php' then
        return
      end
      return { lsp_fallback = true }
    end,
    -- Customize formatters
    formatters = {
      pint = {
        prepend_args = { '--preset', 'laravel' },
        -- prepend_args = { '--preset', 'psr12' },
      },
      phpcbf = {
        prepend_args = { '--standard=PSR12', '--extensions=php' },
      },
    },
  }

  -- If you want the formatexpr, here is the place to set it
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  vim.api.nvim_create_user_command('FormatDisable', function(args)
    if args.bang then
      -- FormatDisable! will disable formatting just for this buffer
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, {
    desc = 'Disable autoformat-on-save',
    bang = true,
  })
  vim.api.nvim_create_user_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
  end, {
    desc = 'Re-enable autoformat-on-save',
  })

  vim.keymap.set('n', '<leader>uf', function()
    if vim.g.disable_autoformat then
      vim.cmd 'FormatEnable'
      vim.notify 'Format on save enabled'
      vim.cmd 'redrawstatus'
    else
      vim.cmd 'FormatDisable'
      vim.notify('Format on save disabled', 3)
      vim.cmd 'redrawstatus'
    end
  end, { desc = 'Toggle format on save' })

  vim.keymap.set('n', '<leader>df', function()
    require('conform').format { async = true, lsp_fallback = true }
  end, { desc = 'Format buffer' })
end)
