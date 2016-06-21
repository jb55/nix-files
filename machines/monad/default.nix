{ config, lib, pkgs, ... }:
{
  imports = [
    ./networking
    ./hardware
    ./environment
  ];

  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
}
