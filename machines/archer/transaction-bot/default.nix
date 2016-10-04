extra:
{ config, lib, pkgs, ... }:
let import-scripts = (import <monstercatpkgs> { }).import-scripts;
in
{
  systemd.services.transaction-bot = {
    enable = true;

    description = "tc transaction bot";

    wantedBy = [ "multi-user.target" ];
    after    = [ "network-online.target" "postgresql.service" ];

    environment = {
      TUNECORE_PASS = extra.private.tc-pass;
    };

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${import-scripts}/bin/tunecore-transaction-bot";
    unitConfig.OnFailure = "notify-failed@%n.service";

    restartIfChanged = false;
    startAt = "Sat *-*-* 01:00:00";
  };
}

