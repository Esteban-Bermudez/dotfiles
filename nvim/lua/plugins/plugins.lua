return {
	"folke/lazy.nvim", -- Add lazy.nvim itself

	-- Mapper
	{
		"Esteban-Bermudez/nvim-mapper",
		dependencies = "nvim-telescope/telescope.nvim",
		config = function()
			require("nvim-mapper").setup({})
		end,
	},

	-- Mdx
	{
		"davidmh/mdx.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},

	-- Debugging
	-- {
	-- 	"leoluz/nvim-dap-go",
	-- 	dependencies = { -- 'requires' becomes 'dependencies'
	-- 		"mfussenegger/nvim-dap",
	-- 		"rcarriga/nvim-dap-ui",
	-- 		"nvim-neotest/nvim-nio",
	-- 	},
	-- 	config = function()
	-- 		require("dap-go").setup({
	-- 			dap_configurations = {
	-- 				{
	-- 					type = "go",
	-- 					name = "Attach remote",
	-- 					mode = "remote",
	-- 					request = "attach",
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },

	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		dependencies = { -- 'requires' becomes 'dependencies'
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("leetcode").setup({
				lang = "golang",
				hooks = {
					enter = function()
						vim.cmd("Copilot disable")
					end,
					leave = function()
						vim.cmd("Copilot enable")
					end,
				},
				injector = {
					golang = {
						imports = function()
							return { "package main" }
						end,
					},
				},
			})
		end,
	},

	{
		"luckasRanarison/tailwind-tools.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
		},
		after = "lsp-zero.nvim",
	},
}
