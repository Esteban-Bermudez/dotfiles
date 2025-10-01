return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate", -- Automatically update parsers on plugin build
	config = function()
		require("nvim-treesitter.configs").setup({
			-- Configure treesitter modules
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = true,
			},
			indent = { enable = true },
			folds = { enable = true },
		})
		vim.treesitter.language.register("markdown", "mdx")
	end,
}
