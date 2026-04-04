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

-- Drive Ghostty's native progress bar via OSC 9;4 sequences
vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local value = ev.data.params.value or {}
    local msg = value.message or 'done'

    if #msg > 40 then
      msg = msg:sub(1, 37) .. '...'
    end

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local name = client and client.name or 'LSP'

    if value.kind == 'end' then
      vim.g.lsp_progress = ''
    else
      local pct = value.percentage and (value.percentage .. '%% ') or ''
      vim.g.lsp_progress = string.format('%s %s%s', name, pct, value.title or msg)
    end

    vim.api.nvim_echo({ { msg } }, false, {
      id = 'lsp',
      kind = 'progress',
      source = 'vim.lsp',
      title = value.title,
      status = value.kind ~= 'end' and 'running' or 'success',
      percent = value.percentage,
    })
    vim.cmd.redrawstatus()
  end,
})
