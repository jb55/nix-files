{ config, lib, pkgs, ... }:
{
  boot.supportedFilesystems = ["ntfs" "exfat"];

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
