{ pkgs, mkDerivation }:
let fetchFromGitHub = pkgs.fetchFromGitHub;
in {
  dbopen = mkDerivation rec {
    name = "dbopen-${version}";
    version = "1.0";
    buildInputs = with pkgs; [ python ];

    src = fetchFromGitHub {
      rev = "e90f8e8ae8f1d914b5445d07b6fe361e1a1eb25b";
      owner = "jb55";
      repo = "dbopen";
      sha256 = "17816w62b61qr2vbk0r3j2djfv67whgpw3wlvmnmdr4f0kqy9g2w";
    };

    configurePhase = "mkdir -p $out/bin";
    makeFlags = "PREFIX=$(out)";
  };
}
