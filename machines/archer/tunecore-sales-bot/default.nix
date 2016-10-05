extra:
{ config, lib, pkgs, ... }:
{
  systemd.services.tunecore-sales-bot = {
    enable = true;

    description = "tc sales bot";

    wantedBy = [ "multi-user.target" ];
    after    = [ "network-online.target" "postgresql.service" ];

    environment = {
      TUNECORE_USER = extra.private.tc-user;
      TUNECORE_PASS = extra.private.tc-pass;
      AWS_ACCESS_KEY_ID = extra.private.aws_access_key;
      AWS_SECRET_ACCESS_KEY = extra.private.aws_secret_key;
    };

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${extra.import-scripts}/bin/tunecore-sales-bot";
    unitConfig.OnFailure = "notify-failed@%n.service";

    restartIfChanged = false;
    # monthly
    startAt = "*-*-01 02:20:00";
  };
}

