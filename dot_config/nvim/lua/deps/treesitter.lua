deps.later(function()
  deps.add {
    source = 'nvim-treesitter/nvim-treesitter',
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

  deps.add {
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    depends = { 'nvim-treesitter/nvim-treesitter' },
  }

  deps.add {
    source = 'windwp/nvim-ts-autotag',
    depends = { 'nvim-treesitter/nvim-treesitter' },
  }
  require('nvim-ts-autotag').setup {
    opts = {
      -- Defaults
      enable_close = true, -- Auto close tags
      enable_rename = true, -- Auto rename pairs of tags
      enable_close_on_slash = true, -- Auto close on trailing </
    },
    -- Also override individual filetype configs, these take priority.
    -- Empty by default, useful if one of the "opts" global settings
    -- doesn't work well in a specific filetype
    -- per_filetype = {
    --   ['html'] = {
    --     enable_close = false,
    --   },
    -- },
  }
end)
