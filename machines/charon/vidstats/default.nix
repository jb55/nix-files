extra:
{ config, lib, pkgs, ... }:
let cfg = extra.private.vidstats;
    videostats = (import (pkgs.fetchgit {
      url    = "http://git.zero.jb55.com/edm-video-stats";
      rev    = "97513a15ebe5181742891702fd31306eb89f66a0";
      sha256 = "0rjy5rq4gniqa1dlig4mg3m6yxchz7hdw5disayr7gxmc6kj18mz";
    }) {}).package;
{
  systemd.services.vidstats = {
    enable = true;

    description = "vidstats bot";

    wantedBy = [ "multi-user.target" ];
    after    = [ "network-online.target" ];

    environment = {
      GOOGLE_SHEET_ID = cfg.sheet_id;
      GOOGLE_API_KEY  = cfg.api_key;
      VIDEOSTATS_RANGE  = cfg.range;
      VIDEOSTATS_STATS_RANGE  = cfg.stats_range;
    };

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${videostats}/bin/video-stats";

    # unitConfig.OnFailure = "notify-failed@%n.service";

    startAt = "*-*-* 05:24:00";
  };
}
