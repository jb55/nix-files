{ config, lib, pkgs, ... }:
{
  boot.supportedFilesystems = ["ntfs" "exfat"];
}
