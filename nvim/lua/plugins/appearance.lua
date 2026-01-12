vim.opt.showmode = false
vim.opt.cmdheight = 1
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    vim.opt.cmdheight = 1
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    vim.opt.cmdheight = 1
  end,
})

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

return {
  -- Hex Colours
  {
    "catgoose/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate", -- Automatically update parsers on plugin build
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },
      indent = { enable = true },
      folds = { enable = true },
    },
    config = function()
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
        globalstatus = true,
        ignore_focus = { "NvimTree", "packer", "TelescopePrompt" },
        disabled_filetypes = {
          statusline = { "NvimTree", "packer" },
          tabline = { "NvimTree", "packer" },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { 'diff', source = diff_source }, { 'b:gitsigns_head', icon = '' }, },
        lualine_c = { { "filename", path = 1, file_status = false, symbols = { modified = "●", unnamed = "~" } } },
        lualine_x = { { "filetype", icon_only = false, align = "right" } },
        lualine_y = { "diagnostics" },
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "buffers",
            show_filename_only = true,
            icons_enabled = false,
            show_modified_status = true,
            symbols = {
              alternate_file = "",
            },
            filetype_names = {
              TelescopePrompt = "",
              NvimTree = "",
            },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
}
