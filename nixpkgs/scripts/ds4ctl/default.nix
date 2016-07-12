{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ds4ctl-${version}";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "jb55";
    repo = "ds4ctl";
    rev = version;
    sha256 = "19kcax09z4kka7f7ilyjq0hwg4wl5871f2nnaqyz3raa91r2wba0";
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
