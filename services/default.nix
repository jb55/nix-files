extra:
{ config, lib, pkgs, ... }:
{
  imports = [
    (import ./pokemongo-map extra)
    ./footswitch
  ];

  services.mongodb.enable = false;
  services.redis.enable = false;

  services.postgresql = {
    enable = false;
    authentication = "local all all ident";
  };

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  services.logrotate = {
    enable = false;
    config = ''
      dateext
      dateformat %Y-%m-%d.
      compresscmd ${pkgs.xz.bin}/bin/xz
      uncompresscmd ${pkgs.xz.bin}/bin/unxz
      compressext .xz
    '';
  };
}
