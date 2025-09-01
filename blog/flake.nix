{
  description = "A development shell for an Eleventy blog.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nodejs_20
            pkgs.yarn
            pkgs.nodePackages.node-gyp
          ];

          shellHook = ''
            echo "Entering Eleventy development shell..."
            export NODE_ENV=development
            yarn install
          '';
        };
      }
    );
}
