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

	-- Theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				-- transparent_background = true,
				background = {
					light = "latte",
					dark = "mocha",
				},
			})
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				theme = "wave",
				background = {
					dark = "wave",
					light = "lotus",
				},
			})
		end,
	},

	-- Dark Notify
	{
		"cormacrelf/dark-notify",
		lazy = false, -- This plugin needs to be loaded eagerly to set the colorscheme
		condition = vim.loop.os_uname().sysname == "Darwin", -- Only load on MACOS
		config = function()
			require("dark_notify").run({
				schemes = {
					dark = "kanagawa-wave",
					light = "catppuccin-latte",
				},
			})
		end,
	},

	-- Hex Colours
	{
		"catgoose/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	-- Github Copilot
	"github/copilot.vim", -- Simple use becomes a string

	-- Mdx
	{
		"davidmh/mdx.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("mdx").setup({})
		end,
	},

	-- Null LS
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { -- 'requires' becomes 'dependencies'
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim", -- none-ls is now null-ls
		},
		config = function()
			require("mason").setup()
			require("mason-null-ls").setup({
				ensure_installed = {
					"prettier",
					"google_java_format",
					"golines",
				},
				automatic_installation = true,
				handlers = {},
			})
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.golines.with({
						extra_args = { "--shorten-comments" },
					}),
					null_ls.builtins.formatting.google_java_format.with({
						filetypes = { "java", "xml" },
						extra_args = { "--aosp" },
					}),
				},
			})
		end,
	},

	-- Debugging
	{
		"leoluz/nvim-dap-go",
		dependencies = { -- 'requires' becomes 'dependencies'
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("dap-go").setup({
				dap_configurations = {
					{
						type = "go",
						name = "Attach remote",
						mode = "remote",
						request = "attach",
					},
				},
			})
		end,
	},

	-- Vim Plugins
	"tpope/vim-commentary",
	"tpope/vim-surround",
	"christoomey/vim-tmux-navigator",
	{
		"m4xshen/autoclose.nvim",
		config = function()
			require("autoclose").setup()
		end,
	},

	{
		"kawre/leetcode.nvim",
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
