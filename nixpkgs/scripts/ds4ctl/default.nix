{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ds4ctl-${version}";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "jb55";
    repo = "ds4ctl";
    rev = version;
    sha256 = "0pq2l0fsksfvxjb2jvv7984pjrw1537wajvr5csl7a1ldvng0llz";
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
