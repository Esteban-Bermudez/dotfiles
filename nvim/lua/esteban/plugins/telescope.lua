local actions = require("telescope.actions")
require("telescope").load_extension("mapper")
require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<Esc>"] = actions.close,
        ["<C-u>"] = false,
        ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
      },
    },
  }
}
print("Telescope loaded")
