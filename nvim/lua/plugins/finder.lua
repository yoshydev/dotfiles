return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
          mappings = {
            -- インサートモード
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-J>"] = actions.preview_scrolling_down,
              ["<C-K>"] = actions.preview_scrolling_up,
              ["<C-H>"] = actions.preview_scrolling_left,
              ["<C-L>"] = actions.preview_scrolling_right,
            },
            -- ノーマルモード
            n = {
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["G"] = actions.move_to_bottom,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<J>"] = actions.preview_scrolling_down,
              ["<K>"] = actions.preview_scrolling_up,
              ["<H>"] = actions.preview_scrolling_left,
              ["<L>"] = actions.preview_scrolling_right,
              ["q"] = actions.close,
              ["<Esc>"] = actions.close,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
