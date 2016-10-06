extra:
{ config, lib, pkgs, ... }:
{
  systemd.services.trend-bot = {
    description = "tc trend bot";

    environment = {
      TUNECORE_USER = extra.private.tc-user;
      TUNECORE_PASS = extra.private.tc-pass;
    };

    serviceConfig.ExecStart = "${extra.import-scripts}/bin/trend-bot";
    unitConfig.OnFailure = "notify-failed@%n.service";

    startAt = "*-*-* 23:59:00";
  };
}

