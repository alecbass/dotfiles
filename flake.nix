{
  description = "Nix flake for editing this repository.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = with pkgs; mkShell {
          buildInputs = [
            neovim # For editing
            lua-language-server # For editing files
            stylua # For conform linting
            opencode
            luaPackages.tree-sitter-cli
          ];
        };
      }
    );
}

