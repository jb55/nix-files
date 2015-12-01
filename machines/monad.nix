pkgs:
{
  sessionCommands = ''
    ${pkgs.xlibs.xinput}/bin/xinput set-prop 8 "Device Accel Constant Deceleration" 3
  '';
}
