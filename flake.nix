{
  description = "Dev environment for Hakyll site using Cabal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.haskellPackages.ghc
            pkgs.haskellPackages.cabal-install
            pkgs.haskellPackages.hakyll
	          pkgs.zlib
          ];
          shellHook = ''
            alias clean="cabal run site clean"
            alias build="cabal run site build"
            alias serve="cabal run site server"
            alias watch="cabal run site watch"
            echo "Aliases: build, clean, serve, watch"
          '';
        };
      });
}

