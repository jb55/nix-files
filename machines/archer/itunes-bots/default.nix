extra:
{ config, lib, pkgs, ... }:
let util = extra.util;
    import-scripts = extra.import-scripts;
    countries = pkgs.fetchurl {
      url    = "https://jb55.com/s/8536f14537bbb417.csv";
      sha256 = "9c31690e31f5a26b12bc5a16d3a1508a06ac1d842e4a129868bc7aaf33358ab5";
    };
in
{
  systemd.user.services.itunes-sales-bot = {
    description = "itunes sales bot";

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    environment = {
      ISO_3166_COUNTRIES = countries;
    };

    serviceConfig.ExecStart = "${import-scripts}/bin/itunes-sales-bot";
    unitConfig.OnFailure = "notify-failed-user@%n.service";

    # First tuesday of every month @ 1600
    startAt = "Tue *-*-1..7 11:30:00";
  };

  systemd.user.services.itunes-transaction-bot = {
    description = "itunes transaction bot";

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    serviceConfig.ExecStart = "${import-scripts}/bin/itunes-transaction-bot";
    unitConfig.OnFailure = "notify-failed-user@%n.service";

    # First tuesday of every month @11
    startAt = "Tue *-*-1..7 11:00:00";
  };
}
