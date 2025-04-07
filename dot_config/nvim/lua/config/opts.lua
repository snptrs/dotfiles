local options = {
  autoread = true,
  breakindent = true,
  clipboard = 'unnamedplus',
  cmdheight = 0,
  -- colorcolumn = '81',
  -- cursorline = true,
  expandtab = true,
  guicursor = 'i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150,r-cr-o:hor20',
  hlsearch = true,
  ignorecase = true, -- Case insensitive searching (unless: see smartcase...)
  laststatus = 3,
  linebreak = true,
  -- listchars = 'tab:>-,lead:\\xB7',
  -- messagesopt = 'wait:3000,history:1000',
  mouse = 'a', -- Enable mouse mode
  number = true,
  pumheight = 15, -- Number of entries to show in popup menu
  relativenumber = true,
  scrolloff = 8,
  sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions',
  shiftwidth = 2,
  shortmess = 'IltToOCFWc',
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
  winbar = '%f %m',
  winborder = 'rounded',
}

local globals = {
  mapleader = ' ',
}

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

vim.opt.fillchars:append { diff = '╱' }

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
    vim.highlight.on_yank { timeout = 250 }
  end,
  desc = 'Highlight yanked text',
})

vim.api.nvim_create_autocmd('WinEnter', {
  group = gr,
  pattern = '*',
  callback = function()
    vim.cmd 'set cul'
    vim.cmd 'set colorcolumn=81'
  end,
  desc = 'Show cursorline on WinEnter',
})

vim.api.nvim_create_autocmd('WinLeave', {
  group = gr,
  pattern = '*',
  callback = function()
    vim.cmd 'set nocul'
    vim.cmd 'set colorcolumn=0'
  end,
  desc = 'Hide cursorline on WinLeave',
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = gr,
  pattern = '*.log',
  callback = function()
    vim.cmd 'checktime'
  end,
  desc = 'Reload buffer when updated',
})

vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = gr,
  pattern = '*',
  callback = function()
    vim.notify 'Buffer reloaded due to file change'
  end,
  desc = 'Notify when buffer reloaded',
})

vim.diagnostic.config { virtual_text = true }

local function paste()
  return {
    vim.split(vim.fn.getreg '', '\n'),
    vim.fn.getregtype '',
  }
end

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy '+',
    ['*'] = require('vim.ui.clipboard.osc52').copy '*',
  },
  paste = {
    ['+'] = paste,
    ['*'] = paste,
  },
}
