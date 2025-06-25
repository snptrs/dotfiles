local map = vim.keymap.set

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true, unique = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, unique = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, unique = true })

-- [[ SP's keymaps ]]
vim.keymap.set('n', '-', function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
    MiniFiles.reveal_cwd()
  end
end, { desc = 'Tree focus', unique = true })

-- Split Navigation
map('n', '<Left>', '<C-w>h', { desc = 'Switch to the left split', unique = true })
map('n', '<Right>', '<C-w>l', { desc = 'Switch to the right split', unique = true })
map('n', '<Down>', '<C-w>j', { desc = 'Switch to the bottom split', unique = true })
map('n', '<Up>', '<C-w>k', { desc = 'Switch to the top split', unique = true })

function YankBufferAsMarkdownCodeBlock()
  local filename = vim.fn.expand '%:p:~:.:h' .. '/' .. vim.fn.expand '%:t'
  local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  local markdown = 'Filename: ' .. filename .. '\n```\n' .. content .. '\n```'
  vim.fn.setreg('+', markdown)
  vim.notify 'Yanked buffer as Markdown code block'
end

-- Map in Lua
vim.keymap.set('n', '<leader>ym', YankBufferAsMarkdownCodeBlock, { desc = 'Yank buffer as codeblock' })
