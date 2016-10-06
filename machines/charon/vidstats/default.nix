extra:
{ config, lib, pkgs, ... }:
let cfg = extra.private.vidstats;
    videostats = (import (pkgs.fetchgit {
      url    = "http://git.zero.jb55.com/edm-video-stats";
      rev    = "a6a928d0603be012c9415ece95f3f8b6ff23cab";
      sha256 = "1xdr1ikslbw719shzqhbf88xfnrxjzq5fhf4dr095388jvh5c6zd";
    }) {}).package;
    client_secret = pkgs.fetchurl {
      name = "client_secret.json";
      url = "http://git.zero.jb55.com/repos/?p=edm-video-stats;a=blob_plain;f=client_secret.json";
      sha256 = "0i1kwq8zy1s1w7db3yh6687hyh44m5g5xrlxc425nfnl6hzl9187";
    };
in
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
      TOKEN_DIR = "/home/jb55/.config/edm/videostats/credentials";
      VIDEOSTATS_STATS_RANGE  = cfg.stats_range;
      CLIENT_SECRET = "${client_secret}";
    };

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${videostats}/bin/video-stats";

    # unitConfig.OnFailure = "notify-failed@%n.service";

    startAt = "*-*-* 05:24:00";
  };
}
