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
      SHOPIFY_USER = extra.private.beatport-user;
      SHOPIFY_PASS = extra.private.beatport-pass;
    };

    serviceConfig.ExecStart = "${import-scripts}/bin/beatport-sales-bot";
    unitConfig.OnFailure = "notify-failed-user@%n.service";

    # 20th is always before the earliest possible last wednesday (22nd)
    startAt = "*-*-05 7:30:00";
  };
}
