extra:
{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  services.mongodb.enable = true;
  services.redis.enable = true;

  services.xserver.libinput.enable = true;
  services.xserver.config = ''
    Section "InputClass"
      Identifier     "Enable libinput for TrackPoint"
      MatchProduct   "PS/2 Generic Mouse"
      Driver         "libinput"
      Option         "ScrollMethod" "button"
      Option         "ScrollButton" "8"
      Option         "AccelSpeed" "0"
    EndSection
  '';

  # https://github.com/nmikhailov/Validity90  # driver not done yet
  services.fprintd.enable = false;

  services.acpid.enable = false;
  powerManagement.enable = false;

  networking.wireless.enable = true;
}
