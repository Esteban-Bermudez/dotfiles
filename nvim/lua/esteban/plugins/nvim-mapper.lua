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

Mapper.map(
  'n',
  '<leader>b',
  "<cmd>lua require('telescope.builtin').buffers()<cr>",
  {
    silent = true,
    noremap = true
  },
  "Telescope",
  "buffers",
  "Search for buffers"
)

Mapper.map(
  'n',
  '<leader>rg',
  "<cmd>lua require('telescope.builtin').live_grep()<cr>",
  {
    silent = true,
    noremap = true
  },
  "Telescope",
  "live_grep",
  "Grep codebase"
)

--nvimtree
Mapper.map(
  'n',
  '<C-b>',
  "<cmd>NvimTreeToggle<cr>",
  {
    silent = true,
    noremap = true
  },
  "NvimTree",
  "Toggle",
  "Toggle NvimTree"
)
