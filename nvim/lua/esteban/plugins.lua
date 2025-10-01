local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	-- Packer
	use("wbthomason/packer.nvim")

	-- Mapper
	use({
		"Esteban-Bermudez/nvim-mapper",
		config = function()
			require("esteban.plugins.nvim-mapper")
		end,
		before = "telescope.nvim",
	})

	-- Theme
	use({ "catppuccin/nvim", as = "catppuccin" })
	require("catppuccin").setup({
		-- transparent_background = true,
		background = {
			light = "latte",
			dark = "mocha",
		},
	})

	use({
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
	})

	if vim.loop.os_uname().sysname == "Darwin" then
		use("cormacrelf/dark-notify")
		require("dark_notify").run({
			schemes = {
				dark = "kanagawa-wave",
				light = "catppuccin-latte",
			},
		})
	else
		vim.cmd.colorscheme("kanagawa")
	end

	-- Hex Colours
	use({
		"catgoose/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	})

	-- Github Copilot
	use("github/copilot.vim")

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("esteban.plugins.telescope")
		end,
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
	})

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
		config = function()
			require("esteban.plugins.treesitter")
		end,
	})

	-- LSP Zero
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		requires = {
			--- Uncomment the two plugins below if you want to manage the language servers from neovim
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
		},
		config = function()
			require("esteban.plugins.lsp-zero")
		end,
		before = "tailwind-tools.nvim",
	})

	-- Null LS
	use({
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		requires = {
			"williamboman/mason.nvim", -- Already included in your LSP Zero setup
			"nvimtools/none-ls.nvim", -- none-ls is now null-ls
		},
		config = function()
			require("mason").setup()
			require("mason-null-ls").setup({
				ensure_installed = {
					-- Opt to list sources here, when available in mason.
					"prettier",
					"darker",
					"google_java_format",
				},
				automatic_installation = true,
				handlers = {},
			})
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.google_java_format.with({
						filetypes = { "java", "xml" },
						extra_args = { "--aosp" },
					}),
					-- Anything not supported by mason.
				},
			})
		end,
	})

	-- Debugging
	use({
		"leoluz/nvim-dap-go",
		requires = {
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
	})

	-- Nvim Tree
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("esteban.plugins.nvim-tree")
		end,
	})

	-- Vim Plugins
	use("tpope/vim-commentary")
	use("tpope/vim-surround")
	use("christoomey/vim-tmux-navigator")
	use("m4xshen/autoclose.nvim")
	require("autoclose").setup()

	-- Git Signs
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("esteban.plugins.gitsigns")
		end,
	})

	-- Status Line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
		config = function()
			require("esteban.plugins.lualine")
		end,
	})

  use({
    "kawre/leetcode.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("leetcode").setup({
        lang ="golang",
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
  })

	use({
		"luckasRanarison/tailwind-tools.nvim",
		config = function()
			require("tailwind-tools").setup()
		end,
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
		},
    after = "lsp-zero.nvim",
	})
	-- My plugins here
	-- use 'foo1/bar1.nvim'
	-- use 'foo2/bar2.nvim'

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
