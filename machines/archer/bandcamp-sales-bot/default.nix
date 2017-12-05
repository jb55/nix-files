extra:
{ config, lib, pkgs, ... }:
let cfg = extra.private;
in
{
  systemd.services.bandcamp-sales-bot = {
    description = "bandcamp sales bot";

    environment = {
      BANDCAMP_USER = cfg.bandcamp-user;
      BANDCAMP_PASS = cfg.bandcamp-pass;
      AWS_ACCESS_KEY_ID = cfg.aws_access_key;
      AWS_SECRET_ACCESS_KEY = cfg.aws_secret_key;
    };

    serviceConfig.ExecStart = "${extra.import-scripts}/bin/bandcamp-sales-bot";
    unitConfig.OnFailure = "notify-failed@%n.service";

    # 3rd day of each month
    startAt = "*-*-03 8:30:00";
  };
}
