require('nvim-treesitter').setup()

require('nvim-treesitter').install {
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
}

-- Enable treesitter highlighting and indent for all filetypes with a parser
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Textobjects
require('nvim-treesitter-textobjects').setup {}

vim.keymap.set('n', '<leader>a', function()
  require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner'
end, { desc = 'Swap next parameter' })
vim.keymap.set('n', '<leader>A', function()
  require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner'
end, { desc = 'Swap previous parameter' })

-- Autotag
require('nvim-ts-autotag').setup {
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true,
  },
  per_filetype = {
    ['html'] = {
      enable_close = false,
    },
  },
}
