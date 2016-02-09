home:
{ config, lib, pkgs, ... }:
let calendar = (import ../private.nix).calendar;
in {
  systemd.services.sync-ical2org = {
    description = "Sync gcal calendar to calendar.org";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeScript "ical2org-auto" ''
        #!${pkgs.bash}/bin/bash
        set -e
        caldir="${home}/var/ical2org"
        link="${calendar}"
        mkdir -p "$caldir"
        export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        ${pkgs.curl}/bin/curl -L "$link" \
          | ${pkgs.ical2org}/bin/ical2org > "$caldir/calendar.org"
      '';
    };
    restartIfChanged = false;
    startAt = "*:0/10";
  };
}

