extra:
{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  services.mongodb.enable = true;
  services.redis.enable = true;

  networking.wireless.enable = true;
}
