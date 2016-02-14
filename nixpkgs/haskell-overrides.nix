pkgs: self: super:
let overrideCabal = pkgs.haskell.lib.overrideCabal;
    # monstercatPkgs = import /home/jb55/etc/monstercatpkgs { inherit pkgs; };
in {
  # streaming-wai = self.callPackage ${home}/src/haskell/streaming-wai {};
  # pipes = overrideCabal super.pipes (drv: {
  #   version = "4.1.7";
  #   sha256 = "104620e6868cc2c4f84c85416ecfce32d53fbbbecaacc7466a0566f574f9d616";
  # });
  # pipes-csv = overrideCabal super.pipes-csv (attrs: {
  #   version = "1.4.2";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "jb55";
  #     repo = "pipes-csv";
  #     rev = "061cff94a67b9b090260e0f31eb6eeeed2952632";
  #     sha256 = "0z3mnhy1ims0r60iq3278wrpqsv552cr7b6bmzff2dfy0xd2x48r";
  #   };
  # });
  # language-bash = overrideCabal super.language-bash (attrs: {
  #   testHaskellDepends = with super; [ QuickCheck tasty tasty-quickcheck ];
  #   src = pkgs.fetchFromGitHub {
  #     owner = "jb55";
  #     repo = "language-bash";
  #     rev = "f80672b3b18983a1ba67ceb7cfcfc7216abafc0b";
  #     sha256 = "1dgb5cmc73vj9pvfxl1p1x3j3qr45058wff7gpvvnzf0zm1ycspl";
  #   };
  # });
  # cassava = overrideCabal super.cassava (attrs: {
  #   version = "0.4.3.1";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "jb55";
  #     repo = "cassava";
  #     rev = "2eb6e29bd5e141c1a9f0e980f7ac1c915e06e02a";
  #     sha256 = "1r1dv7yaalxja06jxqi7rjcdkb72mb2prnk8crzqap0gkmbahqcd";
  #   };
  # });
} #// monstercatPkgs.haskellPackages
