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
  '<C-b>',
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
  '<leader>f',
  "<cmd>lua require('telescope.builtin').live_grep()<cr>",
  {
    silent = true,
    noremap = true
  },
  "Telescope",
  "live_grep",
  "Grep codebase"
)

Mapper.map(
  'n',
  '<C-f>',
  "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
  {
    silent = true,
    noremap = true
  },
  "Telescope",
  "current_buffer_fuzzy_find",
  "Fuzzy find in current buffer"
)

--nvimtree
Mapper.map(
  'n',
  '<leader>e',
  "<cmd>NvimTreeToggle<cr>",
  {
    silent = true,
    noremap = true
  },
  "NvimTree",
  "Toggle",
  "Toggle NvimTree"
)

-- GitSigns
Mapper.map(
  'n',
  '<leader>gh',
  "<cmd>lua require('gitsigns').preview_hunk()<CR>",
  {
    silent = true,
    noremap = true
  },
  "GitSigns",
  "preview_hunk",
  "Preview Current Hunk"
)

Mapper.map(
  'n',
  '<leader>hs',
  "<cmd>lua require('gitsigns').stage_hunk()<CR>",
  {
    silent = true,
    noremap = true
  },
  "GitSigns",
  "stage_hunk",
  "Stage Current Hunk"
)
