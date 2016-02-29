{ pkgs
, fetchFromGitHub
, fetchurl
, stdenv
, writeScript
, machineSessionCommands ? ""
}:
let
  regularFiles = builtins.filterSource (f: type: type == "symlink"
                                              || type == "directory"
                                              || type == "regular");
  dotfiles = regularFiles <dotfiles>;
  bgimg = fetchurl {
    url = "http://jb55.com/img/haskell-space-1024x600.jpg";
    md5 = "5887080b0582fe3d27000a16b6a739b1";
  };
  impureSessionCommands = ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.xlibs.xmodmap}/bin/xmodmap ${dotfiles}/.Xmodmap
    ${pkgs.xlibs.xset}/bin/xset r rate 200 50
  '' + "\n" + machineSessionCommands;
  sessionCommands = ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.feh}/bin/feh --bg-fill ${bgimg}
    ${pkgs.clipit}/bin/clipit &
    ${pkgs.xautolock}/bin/xautolock -time 10 -locker slock &
    ${pkgs.xbindkeys}/bin/xbindkeys -f ${dotfiles}/.xbindkeysrc
    ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
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
