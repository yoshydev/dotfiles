return {
  -- アイコン (他プラグインの依存関係)
  { "nvim-tree/nvim-web-devicons", lazy = true },
  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
  -- インデントガイド (snacks.indent に移行)
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
  },
  -- バッファライン (snacks.bufdelete に一部移行、タブラインは維持)
  {
    "romgrk/barbar.nvim",
    enabled = false, -- snacksにタブラインがないため、必要なら true に戻す
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "lewis6991/gitsigns.nvim", -- バッファにgitステータス表示（オプション）
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = true,
      tabpages = true,
      clickable = true,
      icons = {
        buffer_index = false,
        buffer_number = false,
        button = "",
        filetype = { enabled = true },
        separator = { left = "▎", right = "" },
        modified = { button = "●" },
        pinned = { button = "", filename = true },
        inactive = { separator = { left = "▎", right = "" } },
      },
      maximum_padding = 1,
      sidebar_filetypes = {
        ["neo-tree"] = { event = "BufWipeout" },
      },
    },
    keys = {
      { "<A-h>", "<Cmd>BufferPrevious<CR>", desc = "前のバッファ" },
      { "<A-l>", "<Cmd>BufferNext<CR>", desc = "次のバッファ" },
      { "<A-<>", "<Cmd>BufferMovePrevious<CR>", desc = "バッファを左に移動" },
      { "<A->>", "<Cmd>BufferMoveNext<CR>", desc = "バッファを右に移動" },
      { "<A-1>", "<Cmd>BufferGoto 1<CR>", desc = "バッファ1へ" },
      { "<A-2>", "<Cmd>BufferGoto 2<CR>", desc = "バッファ2へ" },
      { "<A-3>", "<Cmd>BufferGoto 3<CR>", desc = "バッファ3へ" },
      { "<A-4>", "<Cmd>BufferGoto 4<CR>", desc = "バッファ4へ" },
      { "<A-5>", "<Cmd>BufferGoto 5<CR>", desc = "バッファ5へ" },
      { "<A-c>", "<Cmd>BufferClose<CR>", desc = "バッファを閉じる" },
      { "<A-p>", "<Cmd>BufferPin<CR>", desc = "バッファをピン留め" },
      { "<leader>bb", "<Cmd>BufferPick<CR>", desc = "バッファを選択" },
      { "<leader>bc", "<Cmd>BufferCloseAllButCurrent<CR>", desc = "他のバッファを全て閉じる" },
    },
  },
}
