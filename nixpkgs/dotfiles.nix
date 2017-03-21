{ pkgs
, fetchFromGitHub
, fetchurl
, stdenv
, writeScript
, machineSessionCommands ? ""
}:
let
  dotfiles = pkgs.jb55-dotfiles;
  bgimg = fetchurl {
    url = "http://jb55.com/img/haskell-space.jpg";
    md5 = "04d86f9b50e42d46d566bded9a91ee2c";
  };
  impureSessionCommands = ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.xlibs.xmodmap}/bin/xmodmap ${dotfiles}/.Xmodmap
    ${pkgs.xlibs.xset}/bin/xset r rate 200 50
  '' + "\n" + machineSessionCommands;
  sessionCommands = ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.feh}/bin/feh --bg-fill ${bgimg}
    ${pkgs.haskellPackages.taffybar}/bin/taffybar &
    ${pkgs.clipit}/bin/clipit &
    ${pkgs.volumeicon}/bin/volumeicon &
    ${pkgs.xautolock}/bin/xautolock -time 10 -locker slock &
    ${pkgs.xbindkeys}/bin/xbindkeys -f ${dotfiles}/.xbindkeysrc
    ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
    ${pkgs.twmn}/bin/twmnd &

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
    ln -s "${dotfiles}" $out/dotfiles
    cp "${xinitrc}" $out/bin/xinitrc
    cp "${xinitrc-refresh}" $out/bin/xinitrc-refresh
    ln -s $out/bin/xinitrc $out/.xinitrc
  '';
}
