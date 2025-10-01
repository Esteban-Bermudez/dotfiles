return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			attach_to_untracked = true,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = false,
				virt_text_pos = "right_align",
				delay = 500,
			},
			current_line_blame_formatter = "<author>, <author_time> - <abbrev_sha> | <summary>",
		},
	},
}
