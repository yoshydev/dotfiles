-- md-render.nvim: Markdown を Neovim 内でリッチにレンダリングする。
-- 画像プレビュー(kitty graphics protocol)は tmux 内では動作しないため、
-- tmux を介さない WezTerm 上で利用すること。
-- Mermaid ダイアグラムのプレビューには mermaid-cli の `mmdc` が必要:
--   npm install -g @mermaid-js/mermaid-cli
-- (未インストール時は `npx -y @mermaid-js/mermaid-cli` にフォールバックするが初回が遅い)
return {
  "delphinus/md-render.nvim",
  version = "*",
  dependencies = {
    { "nvim-tree/nvim-web-devicons", version = "*" }, -- コードブロックのファイルアイコン
    { "delphinus/budoux.lua", version = "*" }, -- 日本語(CJK)のフレーズ単位折り返し
  },
  keys = {
    { "<leader>mp", "<Plug>(md-render-preview)", desc = "Markdown preview (toggle)" },
    { "<leader>mt", "<Plug>(md-render-preview-tab)", desc = "Markdown preview in tab" },
    { "<leader>md", "<Plug>(md-render-demo)", desc = "Markdown render demo" },
  },
}
