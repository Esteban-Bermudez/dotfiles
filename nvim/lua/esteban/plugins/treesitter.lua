require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'ruby', 'html', 'css', 'javascript', 'python', 'typescript', 'svelte', 'markdown', 'lua', 'scss', 'go',
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
  },
}
vim.treesitter.language.register('markdown', 'mdx')
