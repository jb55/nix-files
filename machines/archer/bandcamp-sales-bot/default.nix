extra:
{ config, lib, pkgs, ... }:
let cfg = extra.private;
in
{
  systemd.services.bandcamp-sales-bot = {
    enable = true;

    description = "bandcamp sales bot";

    wantedBy = [ "multi-user.target" ];
    after    = [ "network-online.target" "postgresql.service" ];

    environment = {
      BANDCAMP_USER = cfg.bandcamp-user;
      BANDCAMP_PASS = cfg.bandcamp-pass;
      AWS_ACCESS_KEY_ID = cfg.aws_access_key;
      AWS_SECRET_ACCESS_KEY = cfg.aws_secret_key;
    };

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${extra.import-scripts}/bin/bandcamp-sales-bot";
    unitConfig.OnFailure = "notify-failed@%n.service";

    # monthly
    startAt = "*-*-01 04:20:00";
  };
}
