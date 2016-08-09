extra:
{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware
    ./nginx
  ];

  systemd.services.postgrest = {
    enable = true;
    description = "PostgREST";

    wantedBy = [ "multi-user.target" ];
    after =    [ "postgresql.service" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = ''
      ${pkgs.haskellPackages.postgrest}/bin/postgrest \
        'postgres://pg-dev-zero.monstercat.com/Monstercat' \
        -a jb55
    '';
  };

  services.mongodb.enable = true;
  services.redis.enable = true;

  services.footswitch = {
    enable = true;
    enable-led = true;
    led = "input2::scrolllock";
  };

  networking.firewall.trustedInterfaces = ["zt0" "zt1"];
  networking.firewall.allowedTCPPorts = [ 8999 22 143 80 5000 5432 ];

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5/";
    enable = true;
    # extraPlugins = with pkgs; [ pgmp ];
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
