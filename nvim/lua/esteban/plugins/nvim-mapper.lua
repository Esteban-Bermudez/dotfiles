Mapper = require("nvim-mapper")

-- Disable annoying things:
vim.cmd 'nnoremap K \\<noop>'
vim.cmd 'vnoremap K \\<noop>'
vim.cmd 'nnoremap <c-w>o \\<noop>'
vim.cmd 'vnoremap <c-w>o \\<noop>'

-- Telescope Stuff
Mapper.map(
  'n',
  '<leader><leader>',
  "<cmd>lua require('telescope.builtin').find_files()<cr>",
  {
    silent = true,
    noremap = true
  },
  "Telescope",
  "find_files",
  "Search for files"
)
