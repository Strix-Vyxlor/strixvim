{inputs}: final: prev: let
  pkgs-locked = inputs.nixpkgs.legacyPackages.${final.stdenv.hostPlatform.system};
in {
  strixvim = final.callPackage ./pkgs/strixvim.nix {
    inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
    rust-bin = inputs.rust-overlay.packages;
  };
}
