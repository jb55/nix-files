extra:
{ config, lib, pkgs, ... }:
let ztip = "10.243.14.20";
    tunecore-trend-bot = import (pkgs.fetchurl {
      url = https://jb55.com/s/655208fa649caddf.nix;
      sha1 = "655208fa649caddf5be1049f4edc17bf6b1aa2ef";
    }) { inherit pkgs; };
in {
  imports = [
    ./hardware
    (import ./nginx (extra // { inherit ztip; }))
  ];

  networking.extraHosts = ''
    127.0.0.1 melpa.org
  '';

  systemd.services.postgrest = {
    enable = true;
    description = "PostgREST";

    wantedBy = [ "multi-user.target" ];
    after =    [ "postgresql.service" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = ''
      ${pkgs.haskellPackages.postgrest}/bin/postgrest \
        'postgres://pg-dev-zero.monstercat.com/Monstercat' \
        -a jb55 \
        +RTS -N -I2
    '';
  };

  services.mongodb.enable = true;
  services.redis.enable = true;
  services.gitlab.enable = false;
  services.gitlab.databasePassword = "gitlab";

  services.footswitch = {
    enable = true;
    enable-led = true;
    led = "input3::scrolllock";
  };

  networking.firewall.trustedInterfaces = ["zt0" "zt1"];
  networking.firewall.allowedTCPPorts = [ 8999 22 143 80 5000 5432 ];

  services.fcgiwrap.enable = true;

  systemd.services.trend-bot = {
    enable = true;

    description = "tc trend bot";

    wantedBy = [ "multi-user.target" ];
    after    = [ "network-online.target" "postgresql.service" ];

    environment = {
      TC_PASS = extra.private.tc-pass;
    };

    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    serviceConfig.ExecStart = pkgs.writeScript "trend-bot" ''
      #!${pkgs.bash}/bin/bash
      day=$(date "--date=today -3 days" +%F)
      sql=$(cat <<EOF
      BEGIN;
      DELETE FROM tunecore_trends WHERE period = '$day';
      COPY tunecore_trends FROM STDIN CSV;
      COMMIT;
      EOF
      )
      ${tunecore-trend-bot}/bin/tunecore-trend-bot $day $day | \
        ${pkgs.gnused}/bin/sed 1d | \
        ${pkgs.postgresql}/bin/psql 'postgresql://jb55@pg-dev-zero.monstercat.com/Monstercat' -c "$sql"
    '';

    restartIfChanged = false;
    startAt = "*-*-* 23:59:00";
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5/";
    enable = true;
    # extraPlugins = with pkgs; [ pgmp ];
    authentication = pkgs.lib.mkForce ''
      # type db  user address        method
      local  all all                 trust
      host   all all  10.243.0.0/16  trust
      host   all all  192.168.1.0/16 trust

    '';
    extraConfig = ''
      listen_addresses = '10.243.14.20,192.168.1.49'
    '';
  };
}
