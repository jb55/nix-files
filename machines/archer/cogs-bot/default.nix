extra:
{ config, lib, pkgs, ... }:
let cfg = extra.private;
    util = extra.util;
    import-scripts = extra.import-scripts;
in
{
  systemd.user.services.cogs-bot = {
    description = "cogs bot";

    serviceConfig.ExecStart = "${import-scripts}/bin/cogs-bot daily-check";
    unitConfig.OnFailure = "notify-failed@%n.service";

    # 20th is always before the earliest possible last wednesday (22nd)
    startAt = "*-*-* 5:30:00";
  };
}
