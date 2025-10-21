{
  lib,
  gcc,
  gnumake,
  ripgrep,
  fzf,
  lazygit,
  unzip,
  nil,
  statix,
  deadnix,
  manix,
  alejandra,
  jdt-language-server,
  google-java-format,
  vscode-langservers-extracted,
  typescript-language-server,
  yaml-language-server,
  lua-language-server,
  kotlin-language-server,
  stylua,
  black,
  isort,
  pyright,
  python3,
  ktfmt,
  rust-bin,
  neovim-unwrapped,
  wrapNeovimUnstable,
  neovimUtils,
  vimPlugins,
  callPackage,
}: let
  lua = neovim-unwrapped.lua;
  lunajson = callPackage ./lunajson.nix {
    inherit (lua.pkgs) buildLuarocksPackage luaOlder;
  };

  luaEnv = lua.withPackages (ps: with ps; [pathlib-nvim lua-utils-nvim lunajson neorg luarocks]);

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
    jdt-language-server
    google-java-format
    kotlin-language-server
    black
    isort
    ktfmt

    vscode-langservers-extracted
    typescript-language-server
    yaml-language-server
    lua-language-server
    stylua
    pyright
    python3
    rust-bin.nightly.latest.default
  ];

  neovimConfig = neovimUtils.makeNeovimConfig {
    myVimPackage = "strixvim";
    customRC = ''
      set runtimepath^=${./. + "/.."}
      source ${./. + "/.."}/init.lua
    '';
    extraLuaPackages = ps:
      with ps; [
        pathlib-nvim
        lua-utils-nvim
        lunajson
        luarocks
      ];

    plugins = with vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];
  };

  neovim-wrapped =
    wrapNeovimUnstable neovim-unwrapped
    (neovimConfig
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
          "--set"
          "NVIM_APPNAME"
          "svim"
        ];
      });
in
  neovim-wrapped.overrideAttrs (oa: {
    buildPhase =
      oa.buildPhase
      + ''
        mv $out/bin/nvim $out/bin/svim
      '';
    meta.mainProgram = "svim";
  })
