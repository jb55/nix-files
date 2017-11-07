extra:
{ config, lib, pkgs, ... }:
let cfg = extra.private;
    util = extra.util;
    import-scripts = extra.import-scripts;
in
{
  systemd.user.services.beatport-sales-bot = {
    description = "beatport sales bot";

    environment = {
      BEATPORT_USER = extra.private.beatport-user;
      BEATPORT_PASS = extra.private.beatport-pass;
    };

    serviceConfig.ExecStart = "${import-scripts}/bin/beatport-sales-bot";
    unitConfig.OnFailure = "notify-failed-user@%n.service";

    # still no statements on the 5th (or event 7th, try two weeks)
    startAt = "*-*-15 7:30:00";
  };
}
