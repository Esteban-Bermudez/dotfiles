require('lualine').setup({
  options = {
    theme = 'catppuccin',
    section_separators = '',
    component_separators = '',
    globalstatus = true,
    ignore_focus = {}
  },
  sections = {
    lualine_a = { 'mode' },
    -- lualine_b = { 'diff', 'branch' },
    lualine_b = { 'diff' },
    -- lualine_c = { 'b:gitsigns_blame_line' },
    lualine_c = { { 'filename', path = 1, file_status = false, symbols = { modified = '●', unnamed = '~' }, }, },
    lualine_x = { { 'filetype', icon_only = true, align = 'right' }, },
    lualine_y = { 'diagnostics' },
    lualine_z = { 'location' },
  },

  tabline = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { {
      'buffers',
      show_filename_only = true,
      show_modified_status = true,
      symbols = {
        alternate_file = '',
      }
    } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
})
