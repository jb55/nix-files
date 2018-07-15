{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ds4ctl-${version}";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "jb55";
    repo = "ds4ctl";
    rev = version;
    sha256 = "1zv905bhqxb1ksd96i6pwqq5ai1zkn3xf3xc3ky57cxgvb8p5c2a";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ ];

  meta = with stdenv.lib; {
    description = "ds4ctl";
    homepage = "https://github.com/jb55/ds4ctl";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
  };
}
