{ config, lib, pkgs, ... }:
{
  imports = [
    ./networking
    ./hardware
    ./services
  ];
  # sessionCommands = ''
  #   ${pkgs.xlibs.xset}/bin/xset m 0 0
  # '';
}
