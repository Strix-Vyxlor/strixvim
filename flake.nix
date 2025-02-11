{
  description = "Strix Vyxlor neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        lib = inputs.nixpkgs.lib;
        pkgs = import inputs.nixpkgs {
          system = system;
          overlays = [(import inputs.rust-overlay)];
        };

        runDeps = with pkgs; [
          gcc
          gnumake
          ripgrep
          fzf
          lazygit
          unzip
          lua

          nil
          statix
          deadnix
          manix
          alejandra

          vscode-langservers-extracted
          typescript-language-server
          yaml-language-server
          lua-language-server
          stylua
          pyright
          mdformat
          rust-bin.stable.latest.default
        ];

        nvim =
          pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped
          (pkgs.neovimUtils.makeNeovimConfig {
              customRC = ''
                set runtimepath^=${./.}
                source ${./.}/init.lua
              '';
              extraLuaPackages = ps:
                with ps; [
                  pathlib-nvim
                  lua-utils-nvim
                ];
            }
            // {
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
