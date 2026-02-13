return {
  -- ファイラー (snacks.explorer に移行)
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
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
