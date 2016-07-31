extra:
{ config, lib, pkgs, ... }:
{
  imports = [
    ./networking
    ./hardware
    ./nginx
  ];

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5/";
    enable = true;
    authentication = ''
      # type db  user address        method
      local  all all                 trust
      host   all all  127.0.0.1/32   trust
      host   all all  172.24.0.0/16  trust
    '';
  };

  systemd.services.postgrest = {
    description = "PostgREST";

    wantedBy = [ "multi-user.target" ];
    after = [ "postgresql.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = ''
      ${pkgs.haskellPackages.postgrest}/bin/postgrest \
        'postgres://localhost/wineparty' \
        -a jb55
    '';
  };

  systemd.services.postgrest.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 443 80 5432 ];
} // let enabler = x: { systemd.services."pogom${x.subdomain}" };
     in lib.lists.fold {a: b: a // b} {} (map enabler extra.private.pokemaps);
