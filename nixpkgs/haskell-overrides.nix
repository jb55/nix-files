pkgs: self: super:
let overrideCabal = pkgs.haskell.lib.overrideCabal;
in {
  pipes-csv = overrideCabal super.pipes-csv (attrs: {
    version = "1.4.2";
    src = pkgs.fetchFromGitHub {
      owner = "jb55";
      repo = "pipes-csv";
      rev = "061cff94a67b9b090260e0f31eb6eeeed2952632";
      sha256 = "0z3mnhy1ims0r60iq3278wrpqsv552cr7b6bmzff2dfy0xd2x48r";
    };
  });
  cassava = overrideCabal super.cassava (attrs: {
    version = "0.4.3.1";
    src = pkgs.fetchFromGitHub {
      owner = "jb55";
      repo = "cassava";
      rev = "2eb6e29bd5e141c1a9f0e980f7ac1c915e06e02a";
      sha256 = "1r1dv7yaalxja06jxqi7rjcdkb72mb2prnk8crzqap0gkmbahqcd";
    };
  });
}
