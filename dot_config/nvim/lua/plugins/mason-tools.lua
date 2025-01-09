return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  dependencies = {
    'williamboman/mason.nvim',
  },
  opts = {
    ensure_installed = {
      'stylua',
      'phpcbf',
      'pint',
      'prettier',
      'prettierd',
      'ruff',
      'rustywind',
      'taplo',
      'isort'
    },
  }
}
