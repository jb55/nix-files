home:
{ config, lib, pkgs, ... }:
let calendars = (import ../private.nix).calendars;
    calendarArgs = with pkgs.lib;
      let xs = mapAttrsToList (n: v: "'" + n + "=" + v.category + "=" + v.link + "'") calendars;
      in concatStringsSep " " xs;
in {
  systemd.services.sync-ical2org = {
    description = "Sync gcal calendar to calendar.org";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = let script = pkgs.writeScript "ical2org-auto" ''
        #!${pkgs.python35}/bin/python3
        import os
        import sys
        from urllib.request import urlopen
        import subprocess
        caldir = "${home}/var/ical2org"
        os.makedirs(caldir, exist_ok=True)
        cat = lambda n: b"#+CATEGORY:    " + bytes(n, "utf-8")
        for arg in sys.argv[1:]:
          [name, category, link] = arg.split("=")
          ical = urlopen(link).read()
          fname = os.path.join(caldir, name + ".org")
          org = open(fname, "wb")
          icalfd = open(os.path.join(caldir, name + ".ical"), "wb")
          icalfd.write(ical)
          icalfd.close()
          # just download for now
          #proc = subprocess.Popen("${pkgs.ical2org}/bin/ical2org",
          #                        close_fds=True,
          #                        stdin=subprocess.PIPE,
          #                        stdout=subprocess.PIPE)
          #out, err = proc.communicate(ical)
          #org.write(out.replace(cat("google"), cat(category)))
          #org.close()
      ''; in "${script} ${calendarArgs}";

    };
    preStart = ''
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    '';
    restartIfChanged = false;
    startAt = "*:0/10";
  };
}

