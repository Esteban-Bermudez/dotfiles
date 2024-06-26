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
    lualine_b = { 'diff', },
    lualine_c = { 'b:gitsigns_blame_line' },
    lualine_x = { 'diagnostics' },
    lualine_y = { { 'filename', path = 1, symbols = { modified = '●' }, }, { 'filetype', padding = 0, icon_only = true }, },
    lualine_z = { 'location' },
  },
})
