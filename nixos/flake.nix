{
  description = "NixOS-WSL system configuration";

  inputs = {
    # システム本体（従来の nixos チャンネル相当）
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # claude-code だけを独立して更新するための入力（従来の nixpkgs-unstable チャンネル相当）
    # 更新: nix flake update nixpkgs-claude
    nixpkgs-claude.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-claude, nixos-wsl, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit nixpkgs-claude; };
      modules = [
        nixos-wsl.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
