deps.now(function()
  deps.add {
    source = 'neovim/nvim-lspconfig',
    depends = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
  }

  -- Mason core
  require('mason').setup {}

  -- Diagnostics
  vim.diagnostic.config {
    severity_sort = true,
    float = { source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    virtual_text = {
      source = 'if_many',
      spacing = 2,
    },
  }

  -- LSP servers and their per-server settings
  local servers = {
    jsonls = {},
    intelephense = {},
    html = { filetypes = { 'html', 'twig', 'hbs' } },
    lua_ls = {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    },
    marksman = {},
    gopls = {},
    pyright = {},
    graphql = {},
    cssls = {
      settings = {
        css = {
          lint = {
            validProperties = { 'composes' },
            unknownAtRules = 'ignore',
          },
        },
      },
    },
    eslint = {},
    cssmodules_ls = {},
    vtsls = {},
  }

  -- Install only NON-LSP tools here (use Mason package names)
  require('mason-tool-installer').setup {
    ensure_installed = {
      'phpcbf',
      'pint',
      'prettier',
      'prettierd',
      'ruff',
      'rustywind',
      'stylua',
      'taplo',
    },
    run_on_start = true,
    auto_update = false,
    start_delay = 0,
  }

  -- Let mason-lspconfig handle LSP server installs (use lspconfig server names)
  local lsp_names = vim.tbl_keys(servers)
  require('mason-lspconfig').setup {
    ensure_installed = lsp_names,
  }

  -- Configure LSP servers. `mason-lspconfig` will automatically enable them.
  for server_name, config in pairs(servers) do
    vim.lsp.config(server_name, config)
  end
end)
