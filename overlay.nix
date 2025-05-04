final: prev: {
  lunajson = final.callPackage ./pkgs/lunajson.nix {};
  strixvim = final.callPackage ./pkgs/strixvim.nix {};
}
