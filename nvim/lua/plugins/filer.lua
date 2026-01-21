return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view = {
        width = 30,
      },
      filters = {
        dotfiles = false,
      },
    },
  },
}
