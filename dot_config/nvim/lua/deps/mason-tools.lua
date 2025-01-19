deps.later(function()
  deps.add {
    source = 'WhoIsSethDaniel/mason-tool-installer.nvim',
    depends = { 'williamboman/mason.nvim' },
  }
  require('mason-tool-installer').setup {
    ensure_installed = {
      'stylua',
      'phpcbf',
      'pint',
      'prettier',
      'prettierd',
      'ruff',
      'rustywind',
      'taplo',
      'isort',
    },
  }
end)
