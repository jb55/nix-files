extra:
{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ./networking extra)
    (import ./imap-notifier extra)
  ];

  boot.extraModprobeConfig = ''
    options thinkpad_acpi enabled=0
  '';

  services.hoogle = {
    enable = true;
    packages = pkgs.myHaskellPackages;
    haskellPackages = pkgs.haskellPackages;
  };
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

    Section "InputClass"
      Identifier       "Disable TouchPad"
      MatchIsTouchpad  "on"
      Driver           "libinput"
      Option           "Ignore" "true"
    EndSection
  '';

  # https://github.com/nmikhailov/Validity90  # driver not done yet
  services.fprintd.enable = false;

  services.autorandr.enable = true;
  services.acpid.enable = false;
  powerManagement.enable = false;

  networking.wireless.enable = true;
}
