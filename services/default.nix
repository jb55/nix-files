extra:
{ config, lib, pkgs, ... }:
{
  imports = [
    # ./footswitch
    # ./fail-notifier
  ];

  #services.mongodb.enable = true;
  #services.redis.enable = true;

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  services.atd.enable = true;

  services.logrotate = {
    enable = true;
    config = ''
      dateext
      dateformat %Y-%m-%d.
      compresscmd ${pkgs.xz.bin}/bin/xz
      uncompresscmd ${pkgs.xz.bin}/bin/unxz
      compressext .xz
    '';
  };
}
