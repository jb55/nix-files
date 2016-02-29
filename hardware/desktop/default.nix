{ config, lib, pkgs, ... }:
{
  hardware = {
    bluetooth.enable = false;
    pulseaudio = {
      package = pkgs.pulseaudioFull;
      enable = false;
    };
  };
}
