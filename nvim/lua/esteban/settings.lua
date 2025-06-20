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

-- Additional settings for Markdown files
vim.cmd("autocmd FileType markdown setlocal tw=120 spell spelllang=en_ca")

-- Add filetype for MDX files
vim.filetype.add({
  extension = {
    mdx = 'mdx'
  }
})

-- Set color theme
vim.o.termguicolors = true

-- Enable auto-indentation
vim.o.autoindent = true

-- Enable  incremental search and do not maintain highlighting
vim.opt.hlsearch = false
vim.opt.incsearch = true

