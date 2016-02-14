{ config, lib, pkgs, ... }:
{
  services.zerotierone.enable = true;

  services.mongodb.enable = true;
  services.redis.enable = true;

  services.postgresql = {
    enable = true;
    authentication = "local all all ident";
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
  };
}
