{ config, lib, pkgs, ... }:
{
  boot.supportedFilesystems = ["ntfs" "exfat"];

  # disable annoying chromium audit logs
  security.audit.enable = false;
  boot.kernelParams = [ "audit=0" ];

  hardware = {
    bluetooth.enable = true;
    pulseaudio = {
      package = pkgs.pulseaudioFull;
      enable = true;
      support32Bit = true;
    };
    opengl.driSupport32Bit = true;
  };
}
