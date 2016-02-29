{ config, lib, pkgs, ... }:
{
  imports = [
    ./networking
    ./hardware
  ];

  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;
}
