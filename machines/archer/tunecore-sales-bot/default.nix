extra:
{ config, lib, pkgs, ... }:
{
  systemd.user.services.tunecore-sales-bot = {
    description = "tunecore sales bot";

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    environment = {
      TUNECORE_USER = extra.private.tc-user;
      TUNECORE_PASS = extra.private.tc-pass;
      AWS_ACCESS_KEY_ID = extra.private.aws_access_key;
      AWS_SECRET_ACCESS_KEY = extra.private.aws_secret_key;
      PGDATABASE = extra.private.pgdatabase;
      PGHOST = extra.private.pghost;
      PGUSER = extra.private.pguser;
    };

    serviceConfig.ExecStart = "${extra.import-scripts}/bin/tunecore-sales-bot";
    unitConfig.OnFailure = "notify-failed@%n.service";

    # every saturday
    startAt = "Tue *-*-1..7 6:30:00";
  };
}

