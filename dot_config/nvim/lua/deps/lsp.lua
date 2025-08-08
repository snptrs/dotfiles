deps.now(function()
  deps.add {
    source = 'neovim/nvim-lspconfig',
    depends = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
  }
  require('mason').setup {}

  -- Diagnostic Config
  -- See :help vim.diagnostic.Opts
  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        local diagnostic_message = {
          [vim.diagnostic.severity.ERROR] = diagnostic.message,
          [vim.diagnostic.severity.WARN] = diagnostic.message,
          [vim.diagnostic.severity.INFO] = diagnostic.message,
          [vim.diagnostic.severity.HINT] = diagnostic.message,
        }
        return diagnostic_message[diagnostic.severity]
      end,
    },
  }

  local capabilities = require('blink.cmp').get_lsp_capabilities()

  local servers = {
    jsonls = {},
    intelephense = {},
    html = { filetypes = { 'html', 'twig', 'hbs' } },
    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
    marksman = {},
    gopls = {},
    prismals = {},
    pyright = {},
    graphql = {},
    cssls = {
      css = {
        lint = {
          validProperties = { 'composes' },
          unknownAtRules = 'ignore',
        },
      },
    },
    eslint = {},
    cssmodules_ls = {},
    vtsls = {},
  }

  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    'isort',
    'phpcbf',
    'pint',
    'prettier',
    'prettierd',
    'ruff',
    'rustywind',
    'stylua',
    'taplo',
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  require('mason-lspconfig').setup {
    ensure_installed = {},
    automatic_enable = true,
    automatic_installation = false,
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end,
    },
  }
end)
