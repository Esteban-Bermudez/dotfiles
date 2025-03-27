require('lualine').setup({
  options = {
    theme = 'auto',
    section_separators = '',
    component_separators = '',
    globalstatus = true,
    ignore_focus = { 'NvimTree', 'packer', 'TelescopePrompt' },
    disabled_filetypes = {
      statusline = { 'NvimTree', 'packer' },
      tabline = { 'NvimTree', 'packer' }
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'diff', 'branch' },
    lualine_c = { { 'filename', path = 1, file_status = false, symbols = { modified = '●', unnamed = '~' }, }, },
    lualine_x = { { 'filetype', icon_only = false, align = 'right' }, },
    lualine_y = { 'diagnostics' },
    lualine_z = { 'location' },
  },

  tabline = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { {
      'buffers',
      show_filename_only = true,
      icons_enabled = false,
      show_modified_status = true,
      symbols = {
        alternate_file = '',
      },
      filetype_names = {
        TelescopePrompt = '',
        NvimTree = '',
      },
    } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
})

vim.opt.showmode = false
vim.opt.cmdheight = 0
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    vim.opt.cmdheight = 1
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    vim.opt.cmdheight = 0
  end,
})
