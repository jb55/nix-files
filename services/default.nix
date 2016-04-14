{ config, lib, pkgs, ... }:
{
  services.zerotierone.enable = true;

  services.mongodb.enable = true;
  services.redis.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
  };

  services.logrotate = {
    enable = true;
    config = ''
      dateext
      dateformat %Y-%m-%d.
      compresscmd ${pkgs.xz}/bin/xz
      uncompresscmd ${pkgs.xz}/bin/unxz
      compressext .xz
    '';
  };
}
