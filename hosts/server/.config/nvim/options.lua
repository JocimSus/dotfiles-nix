-- 
-- nvim options
--

vim.g.mapleader = " "
vim.g.localleader = " "
vim.g.clipboard = {
  name = "file-clipboard",
  copy = {
    ["+"] = { "sh", "-c", "tee /tmp/clipboard > /dev/null" },
    ["*"] = { "sh", "-c", "tee /tmp/clipboard > /dev/null" },
  },
  paste = {
    ["+"] = { "cat", "/tmp/clipboard" },
    ["*"] = { "cat", "/tmp/clipboard" },
  },
  cache_enabled = 0,
}

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamedplus"
vim.o.undofile = true

vim.o.mousescroll = "ver:3,hor:6"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
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
