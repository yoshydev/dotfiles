return {
  -- GitHub Copilot
  {
    "github/copilot.vim",
    cmd = { "Copilot" },
    event = "InsertEnter",
    config = function()
      -- Tabで補完を受け入れ
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<C-y>", 'copilot#Accept("<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Copilot Accept",
      })
      vim.keymap.set("i", "<C-]>", "<Plug>(copilot-next)", { desc = "Copilot Next" })
      vim.keymap.set("i", "<C-,>", "<Plug>(copilot-previous)", { desc = "Copilot Previous" })
      vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-dismiss)", { desc = "Copilot Dismiss" })
    end,
  },
  -- GitHub Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "github/copilot.vim",
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken",
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatToggle",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat Toggle" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Copilot Explain" },
      { "<leader>cr", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Copilot Review" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Copilot Fix" },
      { "<leader>co", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "Copilot Optimize" },
      { "<leader>cd", "<cmd>CopilotChatDocs<cr>", mode = { "n", "v" }, desc = "Copilot Docs" },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "Copilot Tests" },
      { "<leader>cm", "<cmd>CopilotChatModels<cr>", desc = "Copilot Models" },
    },
    opts = {
      model = "claude-4.5-sonnet",
      window = {
        layout = "vertical",
        width = 0.3,
      },
    },
  },
}
