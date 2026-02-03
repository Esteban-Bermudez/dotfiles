return {
	-- RBS support
	{
		"jlcrochet/vim-rbs",
		ft = { "ruby", "rbs" },
	},
	-- LSP Configuration & Plugins
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"gopls",
			},
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
				}),
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
			})
		end,
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		event = { "BufWritePre" },
		cmd = { "ConformInfo", "ConformFormat" },
		keys = {
			-- Format code with conform and exit visual mode if needed
			vim.keymap.set({ "n", "v" }, "<leader>w", function()
				require("conform").format({ async = true }, function(err)
					if not err then
						local mode = vim.api.nvim_get_mode().mode
						if vim.startswith(string.lower(mode), "v") then
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
						end
					end
				end)
			end, { desc = "Format code" }),
		},
		opts = {
			default_format_opts = {
				timeout_ms = 3000,
				async = false, -- not recommended to change
				quiet = false, -- not recommended to change
				lsp_format = "fallback", -- not recommended to change
			},
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports" },
			},
			-- The options you set here will be merged with the builtin formatters.
			-- You can also define any custom formatters here.
			formatters = {
         prettier = {
            require_cwd = true,
        },
			},
		},
	},
}
