{
  allowBroken = false;
  allowUnfree = true;

  packageOverrides = super: let self = super.pkgs; in
  {
    haskellDevToolsEnv = self.myEnvFun {
      name = "haskellDevTools";
      buildInputs = with self.haskell.packages.ghc784; [
        hindent
        ghc-mod
        ghc-core
        structured-haskell-mode
        hasktags
        pointfree
        cabal-install
        alex happy
      ];
    };

#   haskellPackages = super.haskellPackages.override {
#     overrides = self: super: {
#       hierarchy = self.callPackage ~/dev/haskell/hierarchy {};
#     };
#   };

#   haskell = super.haskell // {
#     packages = super.haskell.packages // {
#       ghc784 = super.haskell.packages.ghc784.override {
#         overrides = self: super: {
#           hierarchy = self.callPackage ~/dev/haskell/hierarchy {};
#         };
#       };
#     };
#   };
  };
}
