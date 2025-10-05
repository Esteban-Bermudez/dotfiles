-- MacOS config
if vim.loop.os_uname().sysname == "Darwin" then
	return {
		-- Theme
		{
			"catppuccin/nvim",
			lazy = false,
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
			lazy = false,
			priority = 1000,
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
		{
			"cormacrelf/dark-notify",
			lazy = false, -- This plugin needs to be loaded eagerly to set the colorscheme
			config = function()
				require("dark_notify").run({
					schemes = {
						dark = "kanagawa-wave",
						light = "catppuccin-latte",
					},
				})
			end,
		},
	}


-- Config for Omarchy Linux
else
	-- Loads the Omarchy theme file but filters out LazyVim references
	local theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
	local colorscheme_to_load = nil

	-- Read the Omarchy theme file to extract colorscheme
	if vim.fn.filereadable(theme_file) == 1 then
		local ok, theme_plugins = pcall(dofile, theme_file)
		if ok and type(theme_plugins) == "table" then
			for _, plugin in ipairs(theme_plugins) do
				if
					type(plugin) == "table"
					and plugin[1] == "LazyVim/LazyVim"
					and plugin.opts
					and plugin.opts.colorscheme
				then
					colorscheme_to_load = plugin.opts.colorscheme
					break
				end
			end
		end
	end

	-- Map Omarchy colorscheme names to actual plugins
	local theme_specs = {
		catppuccin = {
			"catppuccin/nvim",
			name = "catppuccin",
			lazy = false,
			priority = 1000,
			config = function()
				require("catppuccin").setup({})
				vim.cmd.colorscheme("catppuccin")
			end,
		},
		["catppuccin-latte"] = {
			"catppuccin/nvim",
			name = "catppuccin",
			lazy = false,
			priority = 1000,
			config = function()
				require("catppuccin").setup({
					flavour = "latte",
				})
				vim.cmd.colorscheme("catppuccin-latte")
			end,
		},
		tokyonight = {
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("tokyonight")
			end,
		},
		gruvbox = {
			"ellisonleao/gruvbox.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("gruvbox")
			end,
		},
		kanagawa = {
			"rebelot/kanagawa.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("kanagawa")
			end,
		},
		["rose-pine"] = {
			"rose-pine/neovim",
			name = "rose-pine",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("rose-pine")
			end,
		},
		everforest = {
			"neanias/everforest-nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("everforest").setup({
					background = "soft",
				})
				vim.cmd.colorscheme("everforest")
			end,
		},
		nord = {
			"shaunsingh/nord.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("nord")
			end,
		},
		bamboo = {
			"ribru17/bamboo.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("bamboo").setup({})
				require("bamboo").load()
			end,
		},
		matteblack = {
			"tahayvr/matteblack.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("matteblack")
			end,
		},
		["monokai-pro"] = {
			"gthelding/monokai-pro.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("monokai-pro").setup({
					filter = "ristretto",
					override = function()
						return {
							NonText = { fg = "#948a8b" },
							MiniIconsGrey = { fg = "#948a8b" },
							MiniIconsRed = { fg = "#fd6883" },
							MiniIconsBlue = { fg = "#85dacc" },
							MiniIconsGreen = { fg = "#adda78" },
							MiniIconsYellow = { fg = "#f9cc6c" },
							MiniIconsOrange = { fg = "#f38d70" },
							MiniIconsPurple = { fg = "#a8a9eb" },
							MiniIconsAzure = { fg = "#a8a9eb" },
							MiniIconsCyan = { fg = "#85dacc" },
						}
					end,
				})
				vim.cmd.colorscheme("monokai-pro")
			end,
		},
	}

	-- Return the appropriate theme spec based on what Omarchy selected
	if colorscheme_to_load and theme_specs[colorscheme_to_load] then
		return theme_specs[colorscheme_to_load]
	else
		-- Fallback to bamboo theme for osaka-jade (which doesn't use LazyVim wrapper)
		return theme_specs["kanagawa"]
	end
end
