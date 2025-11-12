-- 
-- nvim options
--

vim.g.mapleader = " "
vim.g.localleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamedplus"

vim.o.mousescroll = "ver:3,hor:6"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.updatetime = 300
vim.o.termguicolors = true
vim.o.mouse = "a"
vim.opt.scrolloff = 8  -- scroll padding

-- move lines up and down with ALT + ...
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- hold selection after indenting
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })
