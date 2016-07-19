{ config, lib, pkgs, ... }:
{
  imports = [
    ./networking
    ./hardware
    ./services
    ./nginx
  ];
  # sessionCommands = ''
  #   ${pkgs.xlibs.xset}/bin/xset m 0 0
  # '';

  systemd.services.postgrest = {
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

  systemd.services.postgrest.enable = true;
}
