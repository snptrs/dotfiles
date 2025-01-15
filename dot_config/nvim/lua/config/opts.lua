local options = {
  autoread = true,
  breakindent = true,
  clipboard = 'unnamedplus',
  cmdheight = 0,
  colorcolumn = '81',
  cursorline = true,
  expandtab = true,
  guicursor = 'i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150,r-cr-o:hor20',
  hlsearch = true,
  ignorecase = true, -- Case insensitive searching (unless: see smartcase...)
  laststatus = 3,
  linebreak = true,
  -- listchars = 'tab:>-,lead:\\xB7',
  mouse = 'a', -- Enable mouse mode
  number = true,
  pumheight = 15, -- Number of entries to show in popup menu
  relativenumber = true,
  scrolloff = 8,
  sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions',
  shiftwidth = 2,
  shortmess = 'IltToOCF',
  -- showbreak = '↪',
  -- showbreak = '󱞵 ',
  showbreak = ' ',
  showmode = false,
  smartcase = true, -- Case sensitive search if \C or capital in search term
  softtabstop = 2,
  spell = false,
  spelllang = 'en_gb',
  tabstop = 4,
  termguicolors = true,
  timeoutlen = 300,
  undofile = true,
  updatetime = 250,
}

local globals = {
  mapleader = ' ',
}

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

vim.opt.fillchars:append { diff = ' ' }

for k, v in pairs(options) do
  vim.opt[k] = v
end

for k, v in pairs(globals) do
  vim.g[k] = v
end

local gr = vim.api.nvim_create_augroup('GeneralAutocommands', {})
vim.api.nvim_create_autocmd('TextYankPost', {
  group = gr,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { timeout = 300 }
  end,
  desc = 'Highlight yanked text',
})
