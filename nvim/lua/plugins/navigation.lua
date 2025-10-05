return {

	-- Nvim Tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { -- 'requires' becomes 'dependencies'
			"nvim-tree/nvim-web-devicons",
		},
		version = "*",
		lazy = false,
		config = function()
			local setup, nvimtree = pcall(require, "nvim-tree")
			if not setup then
				return
			end
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldenable = false --                  " Disable folding at startup.

			vim.opt.termguicolors = true

			local HEIGHT_RATIO = 0.8 -- You can change this
			local WIDTH_RATIO = 0.5 -- You can change this too
			require("nvim-tree").setup({
				disable_netrw = false,
				hijack_netrw = false,
				respect_buf_cwd = true,
				sync_root_with_cwd = true,
				view = {
					relativenumber = true,
					float = {
						enable = true,
						open_win_config = function()
							local screen_w = vim.opt.columns:get()
							local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
							local window_w = screen_w * WIDTH_RATIO
							local window_h = screen_h * HEIGHT_RATIO
							local window_w_int = math.floor(window_w)
							local window_h_int = math.floor(window_h)
							local center_x = (screen_w - window_w) / 2
							local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
							return {
								border = "rounded",
								relative = "editor",
								row = center_y,
								col = center_x,
								width = window_w_int,
								height = window_h_int,
							}
						end,
					},
					width = function()
						return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
					end,
				},
			})
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			"Esteban-Bermudez/nvim-mapper",
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").load_extension("mapper")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<Esc>"] = actions.close,
							["<C-u>"] = false,
							["<C-d>"] = actions.delete_buffer + actions.move_to_top,
						},
					},
				},
				pickers = {
					git_files = {
						recurse_submodules = false,
					},
					buffers = {
						theme = "dropdown",
					},
					current_buffer_fuzzy_find = {
						theme = "dropdown",
					},
				},
			})

			-- fall back to find_files if git_files can't find anything
			require("telescope.config").project_files = function(opts)
				local ok = pcall(require("telescope.builtin").git_files, opts)
				if not ok then
					require("telescope.builtin").find_files(opts)
				end
			end
		end,
	},
}
