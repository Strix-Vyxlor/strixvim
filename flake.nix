{
  description = "Strix Vyxlor neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
          overlays = [
            (import inputs.rust-overlay) 
            self.overlays.neovim
          ];
        };

        nvimLua = pkgs.neovim-unwrapped.lua;

        lunajson = nvimLua.pkgs.buildLuarocksPackage {
          pname = "lunajson";
          version = "1.2.3-1";
          knownRockspec =
            (pkgs.fetchurl {
              url = "mirror://luarocks/lunajson-1.2.3-1.rockspec";
              sha256 = "1zqjyd90skjhmbmrisxrlsx1wzckrxg66ha3yf2dp71p6hnblfbp";
            }).outPath;
          src = pkgs.fetchFromGitHub {
            owner = "grafi-tt";
            repo = "lunajson";
            rev = "1.2.3";
            hash = "sha256-LZipetkhtScHhI78OFLVkEjpQyvdkbMM0Y2TGFQ7dvg=";
          };

          meta = {
            homepage = "https://github.com/grafi-tt/lunajson";
            description = "A strict and fast JSON parser/decoder/encoder written in pure Lua";
            license.fullName = "MIT/X11";
          };
        };

        luaEnv = nvimLua.withPackages (ps: with ps; [pathlib-nvim lua-utils-nvim lunajson]);

        runDeps = with pkgs; [
          gcc
          gnumake
          ripgrep
          fzf
          lazygit
          unzip
          luaEnv

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
                  lunajson
                ];
            }
            // {
              wrapperArgs = [
                "--prefix"
                "PATH"
                ":"
                "${lib.makeBinPath runDeps}"
                "--prefix"
                "LUA_PATH"
                ";"
                (nvimLua.pkgs.luaLib.genLuaPathAbsStr luaEnv)
                "--prefix"
                "LUA_CPATH"
                ";"
                (nvimLua.pkgs.luaLib.genLuaCPathAbsStr luaEnv)
              ];
            });
      in {
        homeManagerModules = rec {
          strixvim = ./module;
          default = strixvim;
        };

        overlays = rec {
          neovim = _: _prev: {
            neovim = nvim;
          };
          default = neovim;
        };

        packages = rec {
          neovim = nvim;
          default = neovim;
        };
      }
    );
}
