{ config, lib, pkgs, ... }:
{
  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5/";
    enable = true;
    authentication = pkgs.lib.mkForce ''
      # type db  user address        method
      local  all all                 trust
      host   all all  10.243.0.0/16  trust
    '';
    extraConfig = ''
      listen_addresses = '10.243.14.20'
    '';
  };
}
