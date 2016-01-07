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
    rev = "5e6282c2be7dbf58d95741fb8b6349c588051249";
    sha256 = "0gfszgmny1qss1k9cl5v1jvq3cqqvw1f19vbdh415sc38frvk1sl";
  };
  bgimg = fetchurl {
    url = "http://jb55.com/img/haskell-space.jpg";
    md5 = "04d86f9b50e42d46d566bded9a91ee2c";
  };
  sessionCommands = ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.feh}/bin/feh --bg-fill ${bgimg}
    ${pkgs.haskellPackages.taffybar}/bin/taffybar &
    ${pkgs.parcellite}/bin/parcellite &
    ${pkgs.xautolock}/bin/xautolock -time 10 -locker slock &
    ${pkgs.xbindkeys}/bin/xbindkeys -f ${dotfiles}/.xbindkeysrc
    ${pkgs.xlibs.xmodmap}/bin/xmodmap ${dotfiles}/.Xmodmap
    ${pkgs.xlibs.xinput}/bin/xinput set-prop 8 "Device Accel Constant Deceleration" 3
    ${pkgs.xlibs.xset}/bin/xset r rate 200 50
   '' + "\n" + machineSessionCommands;
  xinitrc = writeScript "xinitrc" sessionCommands;
in stdenv.mkDerivation rec {
  name = "jb55-config-${version}";
  version = "git-2015-12-26";

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    echo "user config at '$out'"
    ln -s "${dotfiles}" $out/dotfiles
    cp "${xinitrc}" $out/bin/xinitrc
    ln -s $out/bin/xinitrc $out/.xinitrc
  '';
}
