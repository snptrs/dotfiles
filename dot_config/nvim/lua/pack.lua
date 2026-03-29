-- Treesitter hook: run TSUpdate on install/update
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end
  end,
})

vim.pack.add {
  -- mini.nvim (must be first — many modules depend on it)
  'https://github.com/nvim-mini/mini.nvim',

  -- colorscheme
  'https://github.com/vague2k/vague.nvim',

  -- completion
  'https://github.com/rafamadriz/friendly-snippets',
  { src = 'https://github.com/Saghen/blink.cmp', version = 'v1.10.1' },

  -- lsp stack
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/neovim/nvim-lspconfig',

  -- treesitter stack
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  'https://github.com/windwp/nvim-ts-autotag',
  'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',

  -- ui / editing
  'https://github.com/folke/snacks.nvim',
  'https://github.com/stevearc/aerial.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/otavioschwanck/arrow.nvim',
  'https://github.com/akinsho/git-conflict.nvim',
  'https://github.com/monaqa/dial.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/wakatime/vim-wakatime',
  'https://github.com/nmac427/guess-indent.nvim',
  'https://github.com/stevearc/quicker.nvim',
  'https://github.com/sourcegraph/amp.nvim',
  'https://github.com/umutondersu/smart-newline.nvim',
  'https://github.com/HiPhish/rainbow-delimiters.nvim',
}

vim.keymap.set('n', '<leader>du', '<cmd>lua vim.pack.update()<cr>', { desc = 'Update plugins' })
