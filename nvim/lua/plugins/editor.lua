-- Vim Plugins
return {
	"tpope/vim-commentary",
	"tpope/vim-surround",

	-- Tmux integration
	"christoomey/vim-tmux-navigator",

	-- Github Copilot
	"github/copilot.vim",

  -- Auto Bracket and Quote Pairing
	{
		"nvim-mini/mini.pairs",
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true, terminal = false },
			-- skip autopair when next character is one of these
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- skip autopair when the cursor is inside these treesitter nodes
			skip_ts = { "string" },
			-- skip autopair when next character is closing pair
			-- and there are more closing pairs than opening pairs
			skip_unbalanced = true,
			-- better deal with markdown code blocks
			markdown = true,
		},
	},
}
