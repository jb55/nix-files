
extra:
{ config, lib, pkgs, ... }:
let cfg = extra.private;
in
{
  systemd.user.services.youtube-pub-sales-bot = {
    description = "youtube publishing sales bot";

    environment = {
      YOUTUBE_TYPE="publishing";
      YOUTUBE_OWNER_ID="svBi-FFZiMepj02zaNfDNQ";
    };

    serviceConfig.ExecStart = "${extra.import-scripts}/bin/youtube-sales-bot";
    unitConfig.OnFailure = "notify-failed-user@%n.service";

    # monthly, more than half way through the month. This is because YouTube
    # updates these sheets all the way up to at most half the month (highest
    # I've seen is ~15th)
    startAt = "*-*-20 11:00:00";
  };
}
