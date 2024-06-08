Mapper = require("nvim-mapper")

-- Disable annoying things:
vim.cmd 'nnoremap K \\<noop>'
vim.cmd 'vnoremap K \\<noop>'
vim.cmd 'nnoremap <c-w>o \\<noop>'
vim.cmd 'vnoremap <c-w>o \\<noop>'

-- Telescope
Mapper.map(
  'n',
  '<leader><leader>',
  "<cmd>lua require('telescope.config').project_files()<cr>",
  {
    silent = true,
    noremap = true
  },
  "Telescope",
  "git_files + find_files",
  "Search for git files and fall back to find_files if git_files can't find anything"
)

Mapper.map(
  'n',
  '<leader>ff',
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
  '<leader>g',
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
local function m_map(mode, l, r, plugin, action, description)
  local opts = {
    silent = true,
    noremap = true,
  }
  Mapper.map(mode, l, "<cmd>lua " .. r .. "<cr>", opts, plugin, action, description)
end

-- Actions
m_map('n', '<leader>hs', "require('gitsigns').stage_hunk()", "GitSigns", "stage_hunk", "Stage hunk")
m_map('n', '<leader>hr', "require('gitsigns').reset_hunk()", "GitSigns", "reset_hunk", "Reset hunk")
m_map('v', '<leader>hs', "require('gitsigns').stage_hunk {vim.fn.line('.'), vim.fn.line('v')}", "GitSigns",
  "stage_hunk_visual", "Stage hunk (visual)")
m_map('v', '<leader>hr', "require('gitsigns').reset_hunk {vim.fn.line('.'), vim.fn.line('v')}", "GitSigns",
  "reset_hunk_visual", "Reset hunk (visual)")
m_map('n', '<leader>hS', "require('gitsigns').stage_buffer()", "GitSigns", "stage_buffer", "Stage buffer")
m_map('n', '<leader>hu', "require('gitsigns').undo_stage_hunk()", "GitSigns", "undo_stage_hunk", "Undo stage hunk")
m_map('n', '<leader>hR', "require('gitsigns').reset_buffer()", "GitSigns", "reset_buffer", "Reset buffer")
m_map('n', '<leader>hp', "require('gitsigns').preview_hunk()", "GitSigns", "preview_hunk", "Preview hunk")
m_map('n', '<leader>hb', "require('gitsigns').blame_line{full=true}", "GitSigns", "blame_line", "Blame line")
m_map('n', '<leader>tb', "require('gitsigns').toggle_current_line_blame()", "GitSigns", "toggle_current_line_blame",
  "Toggle current line blame")
m_map('n', '<leader>hd', "require('gitsigns').diffthis()", "GitSigns", "diffthis", "Diff this")
m_map('n', '<leader>hD', "require('gitsigns').diffthis('~')", "GitSigns", "diffthis_ignore",
  "Diff this (ignore whitespace)")
m_map('n', '<leader>td', "require('gitsigns').toggle_deleted()", "GitSigns", "toggle_deleted", "Toggle deleted")

-- LSP format buffer
Mapper.map(
  'n',
  '<leader>w',
  "<cmd>LspZeroFormat<cr>",
  {
    silent = true,
    noremap = true
  },
  "LSP",
  "buffer_autoformat",
  "Format buffer"
)
