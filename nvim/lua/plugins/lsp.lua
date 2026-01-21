return {
  -- Mason: LSPサーバー管理
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },
  -- Mason と lspconfig の連携
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "pyright",
        },
        automatic_installation = true,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- cmp-nvim-lspがあれば補完機能を拡張
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- LSP共通のキーマップ設定（LspAttachイベントで設定）
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
          map("n", "gr", vim.lsp.buf.references, "Go to References")
          map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
          map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
          map("n", "<leader>D", vim.lsp.buf.type_definition, "Type Definition")
          map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
          map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
        end,
      })

      -- vim.lsp.config を使用した新しい設定方式 (Neovim 0.11+)
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })

      vim.lsp.config("pyright", {
        capabilities = capabilities,
      })

      -- LSPサーバーを有効化
      vim.lsp.enable({ "lua_ls", "ts_ls", "pyright" })
    end,
  },
}
