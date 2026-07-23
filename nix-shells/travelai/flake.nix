{
  # travel.ai 用 dev shell。
  # .node-version / package.json engines が node 24.11.1 完全一致指定のため、
  # 24.11.1 を含む nixpkgs commit に固定している (nixhub.io で検索)。
  # バージョンを上げるときは新しい commit を nixhub で探して差し替える。
  description = "travel.ai dev shell (node 24.11.1)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/af84f9d270d404c17699522fab95bbf928a2d92f";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [ pkgs.nodejs_24 ];
      };
    };
}
