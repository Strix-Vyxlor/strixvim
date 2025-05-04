{
  description = "Strix Vyxlor neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: let
    inherit (inputs.nixpkgs) lib;
  in {
    homeManagerModules = rec {
      strixvim = ./module.nix;
      default = strixvim;
    };

    overlays = rec {
      default = strixvim;
      strixvim = final: prev: import ./overlay.nix final prev;
    };
  };
}
