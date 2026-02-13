-- jkでノーマルモードに戻る
vim.keymap.set("i", "jk", "<Esc>")

-- Visual modeで選択したテキストを取得
local function get_visual_selection()
  vim.cmd('noau normal! "vy')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})
  return text
end

local wk = require("which-key")
wk.add({
  -- Window操作 (<C-w>のプロキシ)
  { "<leader>W", proxy = "<c-w>", group = "windows" },
  -- Buffer操作
  { "<leader>b", group = "buffer", expand = function()
      return require("which-key.extras").expand.buf()
    end
  },
  {
    mode = { "n" },
    -- グループ定義 (公式準拠)
    { "<leader>f", group = "file/find" },
    { "<leader>g", group = "git" },
    { "<leader>s", group = "search" },
    { "<leader>u", group = "ui" },
  },
  {
    mode = { "n", "v" },
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
    { "<leader>w", "<cmd>w<cr>", desc = "Write" },
    -- Copilot Chat
    { "<leader>c", group = "copilot" },
  },
})

