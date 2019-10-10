{ pkgs
, fetchFromGitHub
, fetchurl
, stdenv
, writeScript
, machineSessionCommands ? ""
}:
let
  #dotfiles = pkgs.jb55-dotfiles;
  bgimg = fetchurl {
    url = "https://jb55.com/s/red-low-poly.png";
    sha256 = "e45cc45eb084d615babfae1aae703757c814d544e056f0627d175a6ab18b35ab";
  };
  impureSessionCommands = ''
    #!${pkgs.bash}/bin/bash
  '' + "\n" + machineSessionCommands;
  sessionCommands = ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.feh}/bin/feh --bg-fill ${bgimg}
    ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr

    gpg-connect-agent /bye
    GPG_TTY=$(tty)
    export GPG_TTY
    unset SSH_AGENT_PID
    export SSH_AUTH_SOCK="/run/user/1000/gnupg/S.gpg-agent.ssh"
  '' + "\n" + impureSessionCommands;
  xinitrc = writeScript "xinitrc" sessionCommands;
  xinitrc-refresh = writeScript "xinitrc-refresh" impureSessionCommands;
in stdenv.mkDerivation rec {
  name = "jb55-config-${version}";
  version = "git-2015-01-13";

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    echo "user config at '$out'"
    cp "${xinitrc}" $out/bin/xinitrc
    cp "${xinitrc-refresh}" $out/bin/xinitrc-refresh
    ln -s $out/bin/xinitrc $out/.xinitrc
  '';
}
