-- Leader
vim.g.mapleader = ','

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
     
-- Enable line numbers
vim.o.number = true

-- Enable text wrapping at 80 characters
vim.o.textwidth = 80
vim.o.wrap = true
vim.o.linebreak = true

-- Set tab amount to 2 spaces
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Additional settings for Git commit messages
vim.cmd("autocmd FileType gitcommit setlocal tw=72 spell spelllang=en_ca")

-- Set color theme
vim.o.termguicolors = true
vim.cmd.colorscheme "catppuccin-macchiato"

-- Enable auto-indentation
vim.o.autoindent = true

-- Enable  incremental search and do not maintain highlighting
vim.opt.hlsearch = false
vim.opt.incsearch = true

