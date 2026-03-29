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
  vtsls = {
    on_attach = function(_, bufnr)
      vim.keymap.set('n', '<leader>co', function()
        vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
      end, { buffer = bufnr, desc = 'Organise Imports' })
    end,
  },
}

-- Install LSP servers and tools via mason (use Mason package names)
require('mason-tool-installer').setup {
  ensure_installed = {
    -- LSP servers
    'css-lsp',
    'cssmodules-language-server',
    'eslint-lsp',
    'gopls',
    'graphql-language-service-cli',
    'html-lsp',
    'intelephense',
    'json-lsp',
    'lua-language-server',
    'marksman',
    'pyright',
    'vtsls',
    -- Formatters / linters
    'phpcbf',
    'pint',
    'prettier',
    'prettierd',
    'ruff',
    'rustywind',
    'stylua',
    'taplo',
    'deno',
  },
  run_on_start = true,
  auto_update = false,
  start_delay = 0,
}

-- Configure and enable LSP servers
for server_name, config in pairs(servers) do
  vim.lsp.config(server_name, config)
end
vim.lsp.enable(vim.tbl_keys(servers))
