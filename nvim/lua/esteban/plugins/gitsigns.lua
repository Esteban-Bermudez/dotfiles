require('gitsigns').setup {
  attach_to_untracked = true,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = false,
    virt_text_pos = 'right_align',
    delay = 500,
  },
  current_line_blame_formatter_opts = {
    relative_time = true,
  },
}
