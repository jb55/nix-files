extra:
{ config, lib, pkgs, ... }:
{
  systemd.user.services.tunecore-gaming-sales-bot = {
    description = "tunecore-gaming sales bot";

    environment = {
      TUNECORE_TYPE = "gaming";
      TUNECORE_USER = extra.private.tc-gaming-user;
      TUNECORE_PASS = extra.private.tc-gaming-pass;
      AWS_ACCESS_KEY_ID = extra.private.aws_access_key;
      AWS_SECRET_ACCESS_KEY = extra.private.aws_secret_key;
      PGDATABASE = extra.private.pgdatabase;
      PGHOST = extra.private.pghost;
      PGUSER = extra.private.pguser;
    };

    serviceConfig.ExecStart = "${extra.import-scripts}/bin/tunecore-sales-bot";
    unitConfig.OnFailure = "notify-failed@%n.service";

    # first tuesday on each month
    startAt = "Tue *-*-1..7 8:30:00";
  };
}

