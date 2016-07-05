{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ds4ctl-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "jb55";
    repo = "ds4ctl";
    rev = version;
    sha256 = "0fy629w1yp9ww696nnr2dgg7qvpzildpwbxw71krbmxgahwyckr5";
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
