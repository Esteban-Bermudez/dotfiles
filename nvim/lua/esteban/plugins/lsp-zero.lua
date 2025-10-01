local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

local cmp = require("cmp")

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({
			-- documentation says this is important.
			-- I don't know why.
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	}),
})

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
local to_install = { "lua_ls" }
require("mason").setup({})

if vim.fn.executable("go") == 1 then
	table.insert(to_install, "gopls")
end

require("mason-lspconfig").setup({
	ensure_installed = to_install,
	handlers = {
		lsp_zero.default_setup,

		lua_ls = function()
			--- in this function you can setup
			--- the language server however you want.
			--- in this example we just use lspconfig

			require("lspconfig").lua_ls.setup({
				---
				-- in here you can add your own
				-- custom configuration
				---
			})
		end,

		rubocop = function()
			require("lspconfig").rubocop.setup({
				cmd = { "rubocop", "--lsp" },
				filetypes = { "ruby" },
				root_markers = { "Gemfile", ".git" },
				---
				-- in here you can add your own
				-- custom configuration
				---
			})
		end,
	},
})
