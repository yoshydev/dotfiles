# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, nixpkgs-claude, ... }:

let
  # claude-code 用の nixpkgs（flake input）。
  # 更新: sudo nix flake update nixpkgs-claude --flake /etc/nixos
  claudePkgs = import nixpkgs-claude {
    inherit (pkgs.stdenv.hostPlatform) system;
    config = config.nixpkgs.config;
  };

  # Bitwarden(rbw) の dotenv 形式エントリ (notes 欄) を、コマンド実行時のみ
  # 環境変数として注入するラッパー。シェルに常駐させないことで、AIエージェント等の
  # コンテキストへシークレットが乗る経路を減らす。
  # 使い方: secrets-run env/myproject -- npm run dev
  secrets-run = pkgs.writeShellScriptBin "secrets-run" ''
    set -euo pipefail
    if [ $# -lt 2 ]; then
      echo "usage: secrets-run <rbw-entry> [--] <command> [args...]" >&2
      exit 64
    fi
    entry="$1"; shift
    [ "$1" = "--" ] && shift
    set -a
    . <(${pkgs.rbw}/bin/rbw get --raw "$entry" | ${pkgs.jq}/bin/jq -r '.notes // empty')
    set +a
    exec "$@"
  '';

  # secrets-run の direnv 連携版。プロジェクトの .envrc が export する
  # SECRETS_ENTRY からエントリ名を取るので、cd 後は `sr <cmd>` だけでよい。
  sr = pkgs.writeShellScriptBin "sr" ''
    if [ -z "''${SECRETS_ENTRY:-}" ]; then
      echo "sr: SECRETS_ENTRY is not set (add 'export SECRETS_ENTRY=env/<project>' to .envrc)" >&2
      exit 64
    fi
    exec secrets-run "$SECRETS_ENTRY" -- "$@"
  '';
in

{
  # NixOS-WSL モジュールは flake.nix 側で読み込む

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  wsl.enable = true;
  wsl.defaultUser = "yunip";
  wsl.interop.register = false;
  # WSL の GPU パススルー (/usr/lib/wsl/lib の libdxcore) を mesa d3d12
  # ドライバから使えるようにする。Linux GUI アプリで Vulkan/OpenGL を
  # 使う場合に必要なため残置 (wezterm は Windows 版 + mux 接続に移行済み)。
  wsl.useWindowsDriver = true;

  users.users.yunip = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    # Windows版wezterm の SSHドメイン(mux接続)用
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWqLofkCTetee/c/JMCKyj7GsOqOdY/I3RlWGwSGswT wezterm-mux-win"
    ];
  };

  # Windows版wezterm から WSL 内の wezterm-mux-server へ接続するための sshd。
  # wsl.exe を proxy_command にする方式は、wezterm-gui が子プロセスの stdio に
  # socketpair を渡す実装と wsl.exe の相性で通信不能のため、SSH 経由 (wezterm
  # 内蔵 libssh、子プロセスなし) で mux する。loopback のみで待ち受ける。
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    listenAddresses = [ { addr = "127.0.0.1"; port = 2222; } ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # travel.ai 等の開発環境用 (Ubuntu から移行)
  virtualisation.docker.enable = true;

  time.timeZone = "Asia/Tokyo";

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  # プロジェクト毎の開発環境 (flake dev shell) を cd で自動有効化する
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  environment.systemPackages = with pkgs; [
    claudePkgs.claude-code
    git
    zsh
    neovim
    vim
    tmux
    lazygit
    gh
    gitleaks
    yq-go
    curl
    wget
    tree-sitter
    fzf
    bat
    eza
    zoxide
    direnv
    starship
    fd
    ripgrep
    jq
    rbw # Bitwarden CLI (非公式・高速版)。シークレットは secrets-run 経由で注入する
    pinentry-curses # rbw のマスターパスワード入力用
    secrets-run
    sr
    unzip
    htop
    gcc
    gnumake
    nodejs
    mermaid-cli # md-render.nvim の mermaid プレビュー用 (npx 版は NixOS で Chromium が動かない)
    python3
    google-cloud-sdk
    awscli2
    rustup
    go
    ruby
    jdk
    wezterm # wezterm-mux-server 用 (GUI は Windows 版が担当)
  ];

  # mermaid-cli (ヘッドレス Chromium) が日本語入りの図を描画するのに必要。
  # WSL 内で他に GUI 描画は行わない (wezterm は Windows 版 + mux 接続)。
  fonts.packages = with pkgs; [ noto-fonts-cjk-sans ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
