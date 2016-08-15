{ config, lib, pkgs, ... }:
{
  services.zerotierone.enable = true;

  services.mongodb.enable = false;
  services.redis.enable = false;

  services.postgresql = {
    enable = false;
    authentication = "local all all ident";
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
  };

  services.logrotate = {
    enable = false;
    config = ''
      dateext
      dateformat %Y-%m-%d.
      compresscmd ${pkgs.xz}/bin/xz
      uncompresscmd ${pkgs.xz}/bin/unxz
      compressext .xz
    '';
  };
}
