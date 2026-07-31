{
  # work/notes 用 dev shell。
  # gen-invoice-tfd スキルが使う python3 (openpyxl/pypdf) と file コマンドを提供する。
  # バージョン厳密指定は不要なので nixos-unstable を flake.lock で固定する運用。
  description = "work/notes dev shell (python3 + openpyxl/pypdf, file)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          (pkgs.python3.withPackages (ps: [ ps.openpyxl ps.pypdf ]))
          pkgs.file
        ];
      };
    };
}
