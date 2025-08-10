deps.later(function()
  deps.add {
    source = 'nvim-treesitter/nvim-treesitter',
    depends = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = {
      post_checkout = function()
        vim.cmd 'TSUpdate'
      end,
    },
  }
  ---@diagnostic disable-next-line: missing-fields
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'bash',
      'c',
      'cpp',
      'css',
      'csv',
      'diff',
      'dockerfile',
      'git_config',
      'gitcommit',
      'gitignore',
      'html',
      'fish',
      'go',
      'javascript',
      'json',
      'json5',
      'lua',
      'markdown',
      'markdown_inline',
      'mermaid',
      'php',
      'prisma',
      'python',
      'query',
      'regex',
      'ruby',
      'rust',
      'sql',
      'ssh_config',
      'svelte',
      'toml',
      'tsv',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    textobjects = {
      lsp_interop = {
        enable = true,
        border = 'rounded',
        floating_preview_opts = {},
        peek_definition_code = {
          ['gp'] = '@function.outer',
          ['gP'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end)
