deps.now(function()
  deps.add {
    source = 'neovim/nvim-lspconfig',
    depends = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  }
  require('mason').setup {}
  require('mason-lspconfig').setup {}

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
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = false,
        },
      },
      javascript = {
        tsserver = {
          experimental = {
            enableProjectDiagnostics = true,
          },
        },
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = {
          completeFunctionCalls = false,
        },
        inlayHints = {
          parameterNames = { enabled = 'literals' },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
      typescript = {
        tsserver = {
          experimental = {
            enableProjectDiagnostics = true,
          },
        },
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = {
          completeFunctionCalls = false,
        },
        inlayHints = {
          parameterNames = { enabled = 'literals' },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
  }

  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'
  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  -- capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

  -- [[ Configure LSP ]]
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(client, bufnr)
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>dca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    if client.name == 'vtsls' then
      -- VTSLS keymaps
      vim.keymap.set('n', '<leader>dr', function()
        require('vtsls').commands.file_references(0)
      end, { buffer = bufnr, desc = 'File References' })

      vim.keymap.set('n', '<leader>co', function()
        require('vtsls').commands.organize_imports(0)
      end, { buffer = bufnr, desc = 'Organize Imports' })

      vim.keymap.set('n', '<leader>cs', function()
        require('vtsls').commands.sort_imports(0)
      end, { buffer = bufnr, desc = 'Sort Imports' })

      vim.keymap.set('n', '<leader>cM', function()
        require('vtsls').commands.add_missing_imports(0)
      end, { buffer = bufnr, desc = 'Add missing imports' })

      vim.keymap.set('n', '<leader>cu', function()
        require('vtsls').commands.remove_unused_imports(0)
      end, { buffer = bufnr, desc = 'Remove unused imports' })

      vim.keymap.set('n', '<leader>cD', function()
        require('vtsls').commands.fix_all(0)
      end, { buffer = bufnr, desc = 'Fix all diagnostics' })

      vim.keymap.set('n', '<leader>cV', function()
        require('vtsls').commands.select_ts_version(0)
      end, { buffer = bufnr, desc = 'Select TS workspace version' })
    end
  end

  mason_lspconfig.setup_handlers {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
        filetypes = (servers[server_name] or {}).filetypes,
      }
    end,
  }

  vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
  vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

  local border = {
    { '🭽', 'FloatBorder' },
    { '▔', 'FloatBorder' },
    { '🭾', 'FloatBorder' },
    { '▕', 'FloatBorder' },
    { '🭿', 'FloatBorder' },
    { '▁', 'FloatBorder' },
    { '🭼', 'FloatBorder' },
    { '▏', 'FloatBorder' },
  }
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
end)
