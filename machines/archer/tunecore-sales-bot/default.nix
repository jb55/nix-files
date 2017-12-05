extra:
{ config, lib, pkgs, ... }:
{
  systemd.user.services.tunecore-sales-bot = {
    description = "tc sales bot";

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    environment = {
      TUNECORE_USER = extra.private.tc-user;
      TUNECORE_PASS = extra.private.tc-pass;
      AWS_ACCESS_KEY_ID = extra.private.aws_access_key;
      AWS_SECRET_ACCESS_KEY = extra.private.aws_secret_key;
    };

    serviceConfig.ExecStart = "${extra.import-scripts}/bin/tunecore-sales-bot daily-check";
    unitConfig.OnFailure = "notify-failed@%n.service";

    # monthly, first tuesday
    startAt = "Tue *-*-1..7 10:30:00";
  };
}

