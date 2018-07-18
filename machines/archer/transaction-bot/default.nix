extra:
{ config, lib, pkgs, ... }:
{
  systemd.user.services.transaction-bot = {
    description = "tc transaction bot";

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    environment = {
      TUNECORE_USER = extra.private.tc-user;
      TUNECORE_PASS = extra.private.tc-pass;
    };

    serviceConfig.ExecStart = "${extra.import-scripts}/bin/tunecore-transaction-bot";
    unitConfig.OnFailure = "notify-failed@%n.service";

    startAt = "*-*-* 01:00:00";
  };
}

