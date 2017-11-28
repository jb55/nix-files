extra:
{ config, lib, pkgs, ... }:
let cfg = extra.private;
    util = extra.util;
    import-scripts = extra.import-scripts;
in
{
  systemd.user.services.cogs-bot = {
    description = "cogs bot";

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    environment = {
      COGS_SHEET_ID="1lIluimJqBlGK1yRTmsekwUmk0_Wk0wD9VErUE8z6_dY";
    };

    serviceConfig.ExecStart = "${import-scripts}/bin/cogs-bot daily-check";
    unitConfig.OnFailure = "notify-failed-user@%n.service";

    startAt = "*-*-* 5:30:00";
  };
}
