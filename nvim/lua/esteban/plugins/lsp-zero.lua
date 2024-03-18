local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({ buffer = bufnr })
  lsp_zero.buffer_autoformat()
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'standardrb',
    'solargraph'
  },
  handlers = {
    lsp_zero.default_setup,

    lua_ls = function()
      --- in this function you can setup
      --- the language server however you want.
      --- in this example we just use lspconfig

      require('lspconfig').lua_ls.setup({
        ---
        -- in here you can add your own
        -- custom configuration
        ---
      })
    end,
    standardrb = function()
      --- in this function you can setup
      --- the language server however you want.
      --- in this example we just use lspconfig

      require('lspconfig').standardrb.setup({
        -- in here you can add your own
        -- custom configuration
        ---
      })
    end,

    solargraph = function()
      require('lspconfig').solargraph.setup({
        init_options = { formatting = false },
        settings = {
          solargraph = {
            diagnostics = false,
            useBundler = true
          }
        }
      })
    end,
  },
})
