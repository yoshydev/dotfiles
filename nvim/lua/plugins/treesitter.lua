return {
  -- treesitter: 高精度なシンタックスハイライト（main ブランチ方式・Neovim 0.11+）
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local parsers = {
        "svelte",
        "typescript",
        "javascript",
        "tsx",
        "html",
        "css",
        "json",
        "lua",
        "python",
        "markdown",
        "markdown_inline",
        "yaml",
        "toml",
        "vim",
        "vimdoc",
      }
      require("nvim-treesitter").install(parsers)

      -- 対象filetypeでtreesitterハイライトを有効化
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang then
            -- パーサー未インストールの言語では黙って何もしない
            pcall(vim.treesitter.start, args.buf, lang)
          end
        end,
      })
    end,
  },
}
