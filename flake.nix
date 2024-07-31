{
  description = "Strix Vyxlor neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, ... }: inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      lib = inputs.nixpkgs.lib;
      pkgs = import inputs.nixpkgs {
        system = system;
      };

      runDeps = with pkgs; [
        gcc
        gnumake
        ripgrep
        fzf
      ];

      nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped
        (pkgs.neovimUtils.makeNeovimConfig {
          customRC = ''
            set runtimepath^=${./.}
            source ${./.}/init.lua
          '';
        } // {
          wrapperArgs = [
            "--prefix"
            "PATH"
            ":"
            "${lib.makeBinPath runDeps}"
          ];
      });
    in {
      overlays = {
        neovim = _: _prev: {
          neovim = nvim;
        };
        default = self.overlays.neovim;
      };

      packages = rec {
        neovim = nvim;
        default = neovim;
      };
    }
  );
}
