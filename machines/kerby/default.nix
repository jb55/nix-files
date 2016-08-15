{ config, lib, pkgs, ... }:
{
  imports = [
    ./networking
    ./hardware
  ];

  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;

  services.synergy.client.enable = true;
  services.synergy.client.screenName = "kerby";
  services.synergy.client.serverAddress = "monad";
  services.synergy.client.autoStart = true;
}
