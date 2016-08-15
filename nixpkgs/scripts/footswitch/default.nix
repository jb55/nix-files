{ stdenv, hidapi, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "footswitch-${version}";
  version = "git-2015-06-23";

  src = fetchFromGitHub {
    repo = "footswitch";
    owner = "rgerganov";
    rev = "cbb9091277a34adf236ee90e0f3895e35359051c";
    sha256 = "0b5s8wccvk5825kplac6nzfqjzjfyml6qvk0qpf6md9dq0f9fy16";
  };

  makeFlags = "PREFIX=$(out)";

  patches = [ ./patch.diff ];

  buildInputs = [ hidapi ];

  meta = with stdenv.lib; {
    description = "footswitch usb driver";
    homepage = "https://github.com/rgerganov/footswitch";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
  };
}
