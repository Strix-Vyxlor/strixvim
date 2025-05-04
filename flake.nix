{
  description = "Strix Vyxlor neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {self, ...}: let
    systems = builtins.attrNames inputs.nixpkgs.legacyPackages;
    strixvim-overlay = import ./overlay.nix {inherit inputs;};
  in
    inputs.flake-utils.lib.eachSystem systems (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          # Import the overlay, so that the final Neovim derivation(s) can be accessed via pkgs.<nvim-pkg>
          strixvim-overlay
          (import inputs.rust-overlay)
        ];
      };
    in {
      packages = rec {
        default = strixvim;
        strixvim = pkgs.strixvim;
      };
    })
    // {
      homeManagerModules = rec {
        strixvim = import ./module {inherit inputs;};
        default = strixvim;
      };

      overlays = rec {
        default = strixvim;
        strixvim = strixvim-overlay;
      };
    };
}
