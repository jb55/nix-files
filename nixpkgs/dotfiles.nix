{ pkgs
, fetchFromGitHub
, fetchurl
, stdenv
, writeScript
, machineSessionCommands ? ""
}:
let
  dotfiles = fetchFromGitHub {
    owner = "jb55";
    repo = "dotfiles";
    rev = "853052d386f6c0ee44048fd87fa7db1cd8d73dd7";
    sha256 = "100j8jqpc85dr5ajx5scqmv8qn4rhh2xv3nmpf3kf7bma1kc4zph";
  };
  bgimg = fetchurl {
    url = "http://jb55.com/img/haskell-space.jpg";
    md5 = "04d86f9b50e42d46d566bded9a91ee2c";
  };
  impureSessionCommands = ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.xlibs.xmodmap}/bin/xmodmap ${dotfiles}/.Xmodmap
    ${pkgs.xlibs.xset}/bin/xset r rate 200 50
    ${pkgs.xlibs.xset}/bin/xset m 0 0
  '';
  sessionCommands = ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.feh}/bin/feh --bg-fill ${bgimg}
    ${pkgs.haskellPackages.taffybar}/bin/taffybar &
    ${pkgs.parcellite}/bin/parcellite &
    ${pkgs.xautolock}/bin/xautolock -time 10 -locker slock &
    ${pkgs.xbindkeys}/bin/xbindkeys -f ${dotfiles}/.xbindkeysrc
   '' + "\n" + impureSessionCommands + "\n" + machineSessionCommands;
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
