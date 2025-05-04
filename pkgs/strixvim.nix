{
  stdenv,
  lib,
  gcc,
  gnumake,
  ripgrep,
  fzf,
  lazygit,
  unzip,
  luaEnv,
  nil,
  statix,
  deadnix,
  manix,
  alejandra,
  vscode-langservers-extracted,
  typescript-language-server,
  yaml-language-server,
  lua-language-server,
  stylua,
  pyright,
  mdformat,
  rust-bin,
  wrapNeovimUnstable,
  neovimUtils,
}: neovim-unwrapped: let
  lua = neovim-unwrapped.lua;

  luaEnv = lua.withPackages (ps: with ps; [pathlib-nvim lua-utils-nvim lunajson]);

  runDeps = [
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
    wrapNeovimUnstable neovim-unwrapped
    (neovimUtils.makeNeovimConfig {
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
          (lua.pkgs.luaLib.genLuaPathAbsStr luaEnv)
          "--prefix"
          "LUA_CPATH"
          ";"
          (lua.pkgs.luaLib.genLuaCPathAbsStr luaEnv)
        ];
      });
in
  nvim
