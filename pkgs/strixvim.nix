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
  vimPlugins,
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

  neovimConfig = neovimUtils.makeNeovimConfig {
      myVimPackage = "strixvim";
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

      plugins = with vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
  };

  neovim-wrapped =
    wrapNeovimUnstable neovim-unwrapped
    (neovimConfig // {
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
  neovim-wrapped.overrideAttrs (oa: {
    buildPhase = oa.buildPhase + ''
          mv $out/bin/nvim $out/bin/svim
        '';
    meta.mainProgram = "svim";
  })
