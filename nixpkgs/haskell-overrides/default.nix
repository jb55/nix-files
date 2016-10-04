{ monstercatPkgs }:
pkgs: self: super:
let overrideCabal = pkgs.haskell.lib.overrideCabal;
in {
  # binary-serialise-cbor = super.callPackage (pkgs.fetchurl {
  #   url = "https://jb55.com/s/c356f537dc7ddffd.nix";
  #   sha1 = "c356f537dc7ddffdc225d2f2d0c23632dce16955";
  # }) {};
}
