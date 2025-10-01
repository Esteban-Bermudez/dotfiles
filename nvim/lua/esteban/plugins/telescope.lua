return {
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
