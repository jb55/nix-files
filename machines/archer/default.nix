{ config, lib, pkgs, ... }:
{
  imports = [
    ./networking
    ./hardware
  ];
  # sessionCommands = ''
  #   ${pkgs.xlibs.xset}/bin/xset m 0 0
  # '';
}
