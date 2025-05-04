{inputs}: {
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.programs.strixvim;
in {
  imports = [
    (import ./overlay.nix {inherit inputs;})
  ];

  options.programs.strixvim = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable strixvim
      '';
    };
    env = {
      shell = mkOption {
        type = types.str;
        default = "sh";
        description = ''
          shell to use in floatterm
        '';
      };
      fileManager = mkOption {
        type = types.str;
        default = "none";
        description = ''
          terminal file manager to use (can be any other app)
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.strixvim];

    home.file.".config/svim/env.json".text = builtins.toJSON {
      inherit (cfg.env) shell fileManager;
    };
  };
}
