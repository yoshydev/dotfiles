#!/usr/bin/env bash
# claude-code の更新可否を調べてキャッシュに書き出す。
# statusline-command.sh からバックグラウンドで起動される想定（直接実行も可）。
set -u

cache_dir="$HOME/.cache/claude-statusline"
mkdir -p "$cache_dir"

# 多重起動防止
exec 9>"$cache_dir/update-check.lock"
flock -n 9 || exit 0

# リモートの nixpkgs-unstable にある claude-code のバージョン
# （インストール元チャンネルが nixpkgs-unstable のためこれと比較する）
nixpkgs_ver=$(nix --extra-experimental-features 'nix-command flakes' \
  eval --raw nixpkgs#claude-code.version 2>/dev/null)

# 上流（npm）の最新バージョン
npm_ver=$(curl -sf --max-time 20 \
  https://registry.npmjs.org/@anthropic-ai/claude-code/latest | jq -r '.version // empty')

# 取得失敗 (ネットワーク断・コマンド不足など) で空になったときはキャッシュを
# 更新しない。mtime が古いままになるため次回の statusline 表示で再試行される。
if [ -z "$nixpkgs_ver" ] || [ -z "$npm_ver" ]; then
  exit 0
fi

tmp="$cache_dir/update-check.tmp"
{
  echo "nixpkgs=${nixpkgs_ver}"
  echo "npm=${npm_ver}"
} >"$tmp"
mv "$tmp" "$cache_dir/update-check"
