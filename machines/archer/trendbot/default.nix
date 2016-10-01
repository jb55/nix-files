extra:
{ config, lib, pkgs, ... }:
let import-scripts = (import <monstercatpkgs> { }).import-scripts;
in
{
  systemd.services.trend-bot = {
    enable = true;

    description = "tc trend bot";

    wantedBy = [ "multi-user.target" ];
    after    = [ "network-online.target" "postgresql.service" ];

    environment = {
      TUNECORE_PASS = extra.private.tc-pass;
    };

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${import-scripts}/bin/trend-bot";

    unitConfig.OnFailure = "notify-failed@%n.service";

    restartIfChanged = false;
    startAt = "*-*-* 23:59:00";
  };
}

