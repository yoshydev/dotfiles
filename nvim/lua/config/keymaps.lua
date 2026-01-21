-- jkでノーマルモードに戻る
vim.keymap.set("i", "jk", "<Esc>")

local wk = require("which-key")
wk.add({
  -- Window操作 (<C-w>のプロキシ)
  { "<leader>W", proxy = "<c-w>", group = "windows" },
  -- Buffer操作
  { "<leader>b", group = "buffers", expand = function()
      return require("which-key.extras").expand.buf()
    end
  },
  {
    mode = { "n" },
    -- ファイル検索
    { "<leader>f", group = "find" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    -- ファイルエクスプローラー
    { "<leader>e", group = "explorer" },
    { "<leader>ee", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree Toggle" },
    { "<leader>ef", "<cmd>NvimTreeFocus<cr>", desc = "NvimTree Focus" },
    { "<leader>eo", "<cmd>NvimTreeFindFile<cr>", desc = "NvimTree Find File" },
  },
  {
    mode = { "n", "v" },
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
    { "<leader>w", "<cmd>w<cr>", desc = "Write" },
    -- Copilot Chat
    { "<leader>c", group = "copilot" },
  }
})

