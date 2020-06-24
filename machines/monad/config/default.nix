pkgs: rec {
  hostId = "d7ee0243"; # needed for zfs
  ztip = "172.24.172.111";
  nix-serve = {
    port = 10845;
    bindAddress = ztip;
  };
  sessionCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr -r 144
    ${pkgs.xorg.xgamma}/bin/xgamma -gamma 0.8
  '';
}
