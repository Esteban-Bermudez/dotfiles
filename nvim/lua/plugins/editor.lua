-- Vim Plugins
return {
	"tpope/vim-commentary",
	"tpope/vim-surround",

  -- Tmux integration
	"christoomey/vim-tmux-navigator",

	-- Github Copilot
	"github/copilot.vim",

	{
		"m4xshen/autoclose.nvim",
		config = function()
			require("autoclose").setup()
		end,
	},

}
