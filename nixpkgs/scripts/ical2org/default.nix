{ stdenv, gawk, fetchurl }:
stdenv.mkDerivation rec {
  name = "ical2org-${version}";
  version = "15r1rq9xpjypij0bb89zrscm1wc5czljfyv47z68vmkhimr579az";

  src = fetchurl {
    url = http://orgmode.org/worg/code/awk/ical2org.awk;
    sha256 = version;
  };

  phases = [ "installPhase" ];

  buildInputs = [ gawk ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/ical2org
    chmod +x $out/bin/ical2org
    substituteInPlace $out/bin/ical2org \
      --replace "/usr/bin/awk" "${gawk}/bin/gawk" \
      --replace "max_age = 7" "max_age = -1" \
      --replace "condense = 0" "condense = 1" \
      --replace "original = 1" "original = 0" \
      --replace "preamble = 1" "preamble = 0" \
      --replace 'author = "Eric S Fraga"' 'author = "William Casarin"' \
      --replace 'emailaddress = "e.fraga@ucl.ac.uk"' 'emailaddress = "bill@casarin.me"'
  '';

  meta = with stdenv.lib; {
    description = "Convert ical to org";
    homepage = "http://orgmode.org/worg/org-tutorials/org-google-sync.html";
    license = licenses.free;
    platforms = with platforms;  linux ++ darwin ;
    maintainers = with maintainers; [ jb55 ];
  };
}
