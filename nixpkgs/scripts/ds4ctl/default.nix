{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ds4ctl-${version}";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "jb55";
    repo = "ds4ctl";
    rev = version;
    sha256 = "1vr25gc5bvilcrvgyk1vdgfkwc5zqraxn959kmk33aqz3aayv6m5";
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
