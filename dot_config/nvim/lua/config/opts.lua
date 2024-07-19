local options = {
  autoread = true,
  breakindent = true,
  clipboard = 'unnamedplus',
  cmdheight = 0,
  colorcolumn = '81',
  cursorline = true,
  expandtab = true,
  guicursor = 'n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20-blinkon250-blinkwait700-blinkoff400,i:block-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
  hlsearch = true,
  ignorecase = true, -- Case insensitive searching (unless: see smartcase...)
  laststatus = 3,
  linebreak = true,
  mouse = 'a', -- Enable mouse mode
  number = true,
  pumheight = 15, -- Number of entries to show in popup menu
  relativenumber = true,
  scrolloff = 4,
  sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions',
  shiftwidth = 2,
  shortmess = 'IltToOCF',
  showmode = false,
  smartcase = true, -- Case sensitive search if \C or capital in search term
  softtabstop = 2,
  spell = true,
  spelllang = 'en_gb',
  tabstop = 4,
  termguicolors = true,
  timeoutlen = 300,
  undofile = true,
  updatetime = 250,
  winbar = '%t',
}

local globals = {
  -- loaded_netrw = 1,
  -- loaded_netrwPlugin = 1,
}

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
-- vim.o.completeopt = 'menu,menuone,noselect'

vim.opt.fillchars:append { diff = '╱' }

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

for k, v in pairs(options) do
  vim.opt[k] = v
end

for k, v in pairs(globals) do
  vim.g[k] = v
end
