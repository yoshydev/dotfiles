return {
  -- GitHub Copilot (copilot.lua)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false }, -- nvim-cmpに任せる
      panel = { enabled = false },
      copilot_node_command = vim.fn.expand("~/.nodenv/shims/node"),
    },
  },
  -- copilot-cmp (nvim-cmp統合)
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = true,
  },
  -- GitHub Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua",
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
