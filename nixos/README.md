# NixOS flake 運用チートシート

設定一式はこのディレクトリ（`~/dotfiles/nixos/`）。`/etc/nixos` はここへの symlink。

## 日常操作

```bash
# 設定を編集したら反映（alias: nrs）
sudo nixos-rebuild switch --flake ~/dotfiles/nixos#nixos

# 反映せずビルドだけ試す（設定ミスの検査。alias: nrb）
sudo nixos-rebuild build --flake ~/dotfiles/nixos#nixos
```

⚠️ **新規ファイルを追加したら `git add` してから rebuild**。
flake は git 追跡済みファイルしか見えないため、add 忘れは「file not found」になる（初見殺し）。

## パッケージの更新

```bash
# 全 input を更新（nixpkgs 等 → flake.lock が書き換わる）※sudo 不要
nix flake update --flake ~/dotfiles/nixos

# claude-code だけ更新
nix flake update nixpkgs-claude --flake ~/dotfiles/nixos

# その後、反映
nrs
```

sudo で `nix flake update` しない（flake.lock が root 所有になる）。
更新したら flake.lock をコミットしておく。

## 失敗したときの戻し方

```bash
# 直前の世代に戻す（設定ミスで壊れたとき）
sudo nixos-rebuild switch --rollback

# 世代の一覧
sudo nix-env --list-generations -p /nix/var/nix/profiles/system

# パッケージ更新を巻き戻す（lock を git で戻して rebuild）
git -C ~/dotfiles restore nixos/flake.lock && nrs
```

## パッケージを探す・試す

```bash
nix search nixpkgs firefox        # 検索
nix shell nixpkgs#ripgrep         # インストールせず一時的にシェルへ入れる
nix run nixpkgs#cowsay -- hello   # インストールせず単発実行
```

一時利用で気に入ったら configuration.nix の systemPackages へ追加 → `nrs`。

## ディスク掃除

```bash
# 古い世代と不要 store パスを削除（ロールバック先も消えるので注意）
sudo nix-collect-garbage --delete-older-than 14d
```

## プロジェクト用 dev shell（direnv）

新しいプロジェクトにバージョン固定環境を作る手順:

```bash
# 1. 既存の flake を雛形にコピー
cp -r ~/dotfiles/nix-shells/travelai ~/dotfiles/nix-shells/<project>
# 2. flake.nix を編集（パッケージ・バージョン差し替え）して git add
git -C ~/dotfiles add nix-shells/<project>
# 3. プロジェクト側に .envrc を置いてローカル除外に追加
echo "use flake /home/yunip/dotfiles/nix-shells/<project>" > <repo>/.envrc
echo ".envrc" >> <repo>/.git/info/exclude
# 4. 有効化
direnv allow <repo>
```

- 特定パッチバージョンが必要なら https://www.nixhub.io/packages/nodejs で
  そのバージョンを含む nixpkgs commit を探して input を固定する
- flake.nix を変えた後の反映は `direnv reload`（プロジェクト内で実行）

## 情報表示

```bash
nix flake metadata ~/dotfiles/nixos   # input の pin 状況（lock の中身）
nixos-rebuild list-generations        # 世代と日時の一覧
```
