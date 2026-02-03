Mapper = require("nvim-mapper")
-- Disable annoying things:
vim.cmd("nnoremap K \\<noop>")
vim.cmd("vnoremap K \\<noop>")
vim.cmd("nnoremap <c-w>o \\<noop>")
vim.cmd("vnoremap <c-w>o \\<noop>")

-- Tmux Navigator (use same keys across tmux and nvim)
vim.g.tmux_navigator_no_mappings = 1
local function tmux_nav(mode, lhs, cmd)
	vim.keymap.set(mode, lhs, cmd, { silent = true, noremap = true })
end

tmux_nav("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
tmux_nav("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>")
tmux_nav("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
tmux_nav("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>")
tmux_nav("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>")

tmux_nav("t", "<C-h>", "<C-\\><C-n><cmd>TmuxNavigateLeft<cr>")
tmux_nav("t", "<C-j>", "<C-\\><C-n><cmd>TmuxNavigateDown<cr>")
tmux_nav("t", "<C-k>", "<C-\\><C-n><cmd>TmuxNavigateUp<cr>")
tmux_nav("t", "<C-l>", "<C-\\><C-n><cmd>TmuxNavigateRight<cr>")
tmux_nav("t", "<C-\\>", "<C-\\><C-n><cmd>TmuxNavigatePrevious<cr>")

-- Telescope
Mapper.map(
	"n",
	"<leader><leader>",
	"<cmd>lua require('telescope.config').project_files()<cr>",
	{
		silent = true,
		noremap = true,
	},
	"Telescope",
	"git_files + find_files",
	"Search for git files and fall back to find_files if git_files can't find anything"
)

Mapper.map("n", "<leader>z", "<cmd>lua require('telescope.builtin').spell_suggest()<cr>", {
	silent = true,
	noremap = true,
}, "Telescope", "spell_suggest", "Search through spelling suggestions")

Mapper.map("n", "<leader>f", "<cmd>lua require('telescope.builtin').find_files()<cr>", {
	silent = true,
	noremap = true,
}, "Telescope", "find_files", "Search for files")

Mapper.map("n", "<C-b>", "<cmd>lua require('telescope.builtin').buffers()<cr>", {
	silent = true,
	noremap = true,
}, "Telescope", "buffers", "Search for buffers")

Mapper.map("n", "<leader>g", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {
	silent = true,
	noremap = true,
}, "Telescope", "live_grep", "Grep codebase")

Mapper.map("n", "<C-f>", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", {
	silent = true,
	noremap = true,
}, "Telescope", "current_buffer_fuzzy_find", "Fuzzy find in current buffer")

-- NvimTree
Mapper.map("n", "<leader>E", "<cmd>NvimTreeToggle .<cr>", {
	silent = true,
	noremap = true,
}, "NvimTree", "Toggle", "Toggle NvimTree")

Mapper.map("n", "<leader>e", "<cmd>NvimTreeFindFileToggle .<cr>", {
	silent = true,
	noremap = true,
}, "NvimTree", "Toggle with File", "Toggle NvimTree with current file")

-- GitSigns
local function m_map(mode, l, r, plugin, action, description)
	local opts = {
		silent = true,
		noremap = true,
	}
	Mapper.map(mode, l, "<cmd>lua " .. r .. "<cr>", opts, plugin, action, description)
end

-- Actions
m_map("n", "<leader>hs", "require('gitsigns').stage_hunk()", "GitSigns", "stage_hunk", "Stage hunk")
m_map("n", "<leader>hr", "require('gitsigns').reset_hunk()", "GitSigns", "reset_hunk", "Reset hunk")
m_map(
	"v",
	"<leader>hs",
	"require('gitsigns').stage_hunk {vim.fn.line('.'), vim.fn.line('v')}",
	"GitSigns",
	"stage_hunk_visual",
	"Stage hunk (visual)"
)
m_map(
	"v",
	"<leader>hr",
	"require('gitsigns').reset_hunk {vim.fn.line('.'), vim.fn.line('v')}",
	"GitSigns",
	"reset_hunk_visual",
	"Reset hunk (visual)"
)
m_map("n", "<leader>hS", "require('gitsigns').stage_buffer()", "GitSigns", "stage_buffer", "Stage buffer")
m_map("n", "<leader>hu", "require('gitsigns').undo_stage_hunk()", "GitSigns", "undo_stage_hunk", "Undo stage hunk")
m_map("n", "<leader>hR", "require('gitsigns').reset_buffer()", "GitSigns", "reset_buffer", "Reset buffer")
m_map("n", "<leader>hp", "require('gitsigns').preview_hunk()", "GitSigns", "preview_hunk", "Preview hunk")
m_map("n", "<leader>hb", "require('gitsigns').blame_line{full=true}", "GitSigns", "blame_line", "Blame line")
m_map(
	"n",
	"<leader>tb",
	"require('gitsigns').toggle_current_line_blame()",
	"GitSigns",
	"toggle_current_line_blame",
	"Toggle current line blame"
)
m_map("n", "<leader>hd", "require('gitsigns').diffthis()", "GitSigns", "diffthis", "Diff this")
m_map(
	"n",
	"<leader>hD",
	"require('gitsigns').diffthis('~')",
	"GitSigns",
	"diffthis_ignore",
	"Diff this (ignore whitespace)"
)
m_map("n", "<leader>td", "require('gitsigns').toggle_deleted()", "GitSigns", "toggle_deleted", "Toggle deleted")
m_map(
  "n",
  "]c",
  "require('gitsigns').next_hunk()",
  "GitSigns",
  "next_hunk",
  "Next hunk"
)

m_map(
  "n",
  "[c",
  "require('gitsigns').prev_hunk()",
  "GitSigns",
  "prev_hunk",
  "Previous hunk"
)

-- Next Buffer by pressing tab
Mapper.map("n", "<tab>", "<cmd>bnext<cr>", {
	silent = true,
	noremap = true,
}, "Buffer", "next", "Next buffer")

-- Previous Buffer by pressing shift + tab
Mapper.map("n", "<s-tab>", "<cmd>bprevious<cr>", {
	silent = true,
	noremap = true,
}, "Buffer", "previous", "Previous buffer")

-- Debugging
Mapper.map("n", "<leader>5", "<cmd>lua require('dap').continue()<cr>", {
	silent = true,
	noremap = true,
}, "Debugger", "continue", "Continue/Start debugging")

Mapper.map("n", "<leader>n", "<cmd>lua require('dap').step_over()<cr>", {
	silent = true,
	noremap = true,
}, "Debugger", "step_over", "Step over")

Mapper.map("n", "<leader>8", "<cmd>lua require('dap').step_out()<cr>", {
	silent = true,
	noremap = true,
}, "Debugger", "step_out", "Step out")

Mapper.map("n", "<leader>9", "<cmd>lua require('dap').step_into()<cr>", {
	silent = true,
	noremap = true,
}, "Debugger", "step_into", "Step into")

Mapper.map("n", "<Leader>sb", "<cmd>lua require('dap').toggle_breakpoint()<cr>", {
	silent = true,
	noremap = true,
}, "Debugger", "toggle_breakpoint", "Toggle breakpoint")

-- Make it so that when i press leader y it yanks but into macOS system
-- clipboard with "+y
Mapper.map("v", "<leader>y", '"+y', {
	silent = true,
	noremap = true,
}, "Clipboard Visual", "copy_to_clipboard_visual", "Copy to clipboard in visual mode")

Mapper.map("n", "<leader>y", '"+y', {
	silent = true,
	noremap = true,
}, "Clipboard Normal", "copy_to_clipboard", "Copy to clipboard")

-- LeetCode
Mapper.map("n", "<leader>ll", "<cmd>Leet list<cr>", {
	silent = true,
	noremap = true,
}, "LeetCode List", "leet_list", "Choose a LeetCode problem")

Mapper.map("n", "<leader>ld", "<cmd>Leet desc<cr>", {
	silent = true,
	noremap = true,
}, "LeetCode Description", "leet_desc", "Show problem description")

Mapper.map("n", "<leader>lc", "<cmd>Leet console<cr>", {
	silent = true,
	noremap = true,
}, "LeetCode Console", "leet_console", "Open test console")

Mapper.map("n", "<leader>lr", "<cmd>Leet run<cr>", {
	silent = true,
	noremap = true,
}, "LeetCode Run", "leet_run", "Run code against test cases")
