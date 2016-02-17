pkgs: {
  sessionCommands = ''
    ${pkgs.xlibs.xset}/bin/xset m 3 6
    ${pkgs.xlibs.xinput}/bin/xinput --set-prop 8 'Device Accel Constant Deceleration'
  '';
}
