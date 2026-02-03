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

  -- Opencode
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Leader-based keymaps.
      vim.keymap.set({ "n", "x" }, "<leader>a", function() require("opencode").ask("@this: ", { submit = true }) end,
        { desc = "Ask opencode…" })
      vim.keymap.set({ "n", "x" }, "<leader>oo", function() require("opencode").select() end,
        { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "t" }, "<leader>c", function() require("opencode").toggle() end,
        { desc = "Toggle opencode chat" })

      vim.keymap.set({ "n", "x" }, "<leader>or", function() return require("opencode").operator("@this ") end,
        { desc = "Add range to opencode", expr = true })
      vim.keymap.set("n", "<leader>ol", function() return require("opencode").operator("@this ") .. "_" end,
        { desc = "Add line to opencode", expr = true })

      vim.keymap.set("n", "<leader>ou", function() require("opencode").command("session.half.page.up") end,
        { desc = "Scroll opencode up" })
      vim.keymap.set("n", "<leader>od", function() require("opencode").command("session.half.page.down") end,
        { desc = "Scroll opencode down" })
    end,
  }
}
