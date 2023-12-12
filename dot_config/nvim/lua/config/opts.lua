local options = {
  sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions',
  hlsearch = true,
  number = true,
  scrolloff = 4,
  relativenumber = true,
  expandtab = true,
  shiftwidth = 2,
  softtabstop = 2,
  tabstop = 4,
  mouse = 'a', -- Enable mouse mode
  guicursor = 'n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20-blinkon250-blinkwait700-blinkoff400,i:block-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
  cursorline = true,
  -- colorcolumn = '80',
  showmode = false,
  autoread = true,
  linebreak = true,
  winbar = '%f',
  laststatus = 3,
}

local globals = {
  loaded_netrw = 1,
  loaded_netrwPlugin = 1,
}

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

vim.o.termguicolors = true

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
