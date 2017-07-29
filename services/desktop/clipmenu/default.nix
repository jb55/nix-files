{ config, lib, pkgs, ... }:
with pkgs;
let
  clipmenu = stdenv.mkDerivation rec {
    name = "clipmenu-${version}";
    version = "git-2017-05-31";

    src = fetchFromGitHub {
      owner = "cdown";
      repo  = "clipmenu";
      rev   = "2cd2287612a541260e4a6973045479b354a4febf";
      sha256 = "0pcypdnngy4yj76skyd139lvr359qsl0zvn937a69cxv21rmv2rn";
    };

    buildInputs = [ makeWrapper ];

    buildPhase = "";

    installPhase = ''
      mkdir -p $out/bin
      cp clipmenu clipmenud $out/bin

      wrapProgram "$out/bin/clipmenu" \
        --prefix PATH : "${lib.getBin xsel}/bin:${lib.getBin dmenu2}/bin:${lib.getBin eject}/bin:${lib.getBin gawk}/bin"

      wrapProgram "$out/bin/clipmenud" \
        --prefix PATH : "${lib.getBin xsel}/bin:${lib.getBin dmenu2}/bin:${lib.getBin eject}/bin:${lib.getBin gawk}/bin"
    '';

    meta = with stdenv.lib; {
      description = "clipboard helper";
      inherit (src.meta) homepage;
      maintainers = with maintainers; [ jb55 ];
      license = licenses.publicDomain;
    };
  };
in
{
  systemd.user.services.clipmenu = {
    description = "clipmenu";

    serviceConfig.ExecStart = "${clipmenu}/bin/clipmenud";
  };
}
