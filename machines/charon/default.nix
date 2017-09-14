extra:
{ config, lib, pkgs, ... }:
let adblock-hosts = pkgs.fetchurl {
      url    = "https://jb55.com/s/ad-sources.txt";
      sha256 = "d9e6ae17ecc41eb7021c0552548a1c8da97efbb61e3a750fb023674d01d81134";
    };
    dnsmasq-adblock = pkgs.fetchurl {
      url = "https://jb55.com/s/dnsmasq-ad-sources.txt";
      sha256 = "3b34e565fb240c4ac1d261cb223bdc2d992fa755b5f6e981144e5b18f96f260d";
    };
    gitExtra = {
      git = {
        projectroot = "/var/git";
      };
      host = "git.zero.jb55.com";
    };
    npmrepo = (import (pkgs.fetchFromGitHub {
      owner  = "jb55";
      repo   = "npm-repo-proxy";
      rev    = "81182f25cb783a986d7b7ee4a63f0ca6ca9c8989";
      sha256 = "0zj7ys0383fs3hykax5bd6q5wrhzcipy8j3div83mba2n7c13f8l";
    }) {}).package;
    gitCfg = extra.git-server { inherit config pkgs; extra = extra // gitExtra; };
    hearpress = (import <jb55pkgs> { nixpkgs = pkgs; }).hearpress;
    myemail = "jb55@jb55.com";
in
{
  imports = [
    ./networking
    ./hardware
    (import ./nginx extra)
    (import ./sheetzen extra)
    #(import ./vidstats extra)
  ];

  users.extraGroups.jb55cert.members = [ "prosody" ];

  security.acme.certs."jb55.com" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
    allowKeysForGroup = true;
    email = myemail;
  };

  security.acme.certs."sheetzen.com" = {
    webroot = "/var/www/challenges";
    email = myemail;
  };

  security.acme.certs."hearpress.com" = {
    webroot = "/var/www/challenges";
    email = myemail;
  };

  services.mailz = {
    enable = true;
    domain = "jb55.com";

    users = {
      jb55 = {
        password = "$6$KHmFLeDBaXBE1Jkg$eEN8HM3LpZ4muDK/JWC25qW9xSZq0AqsF4tlzEan7yctROJ9A/lSqz6gN1b1GtwE7efroXGHtDi2FEJ2ujDAl0";
        aliases = [ "postmaster" "bill" "will" "william" "me" "jb" ];
      };
    };

    sieves = builtins.readFile ./dovecot/filters.sieve;
  };

  services.prosody.enable = true;
  services.prosody.admins = [ "jb55@jb55.com" ];
  services.prosody.allowRegistration = false;
  services.prosody.extraModules = [
    "cloud_notify"
    "smacks"
    "carbons"
    "http_upload"
  ];
  services.prosody.extraConfig = ''
    c2s_require_encryption = true
    http_upload_path = "/www/jb55/xmpp-upload"
  '';
  services.prosody.ssl = {
    cert = "${config.security.acme.directory}/jb55.com/fullchain.pem";
    key = "${config.security.acme.directory}/jb55.com/key.pem";
  };
  services.prosody.virtualHosts.jb55 = {
    enabled = true;
    domain = "jb55.com";
    ssl = {
      cert = "${config.security.acme.directory}/jb55.com/fullchain.pem";
      key = "${config.security.acme.directory}/jb55.com/key.pem";
    };
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5/";
    enable = true;
    authentication = ''
      # type db  user address        method
      local  all all                 trust
      host   all all  172.24.0.0/16  trust
    '';
    extraConfig = ''
      listen_addresses = '${extra.ztip}'
    '';
  };

  systemd.services.npmrepo = {
    description = "npmrepo.com";

    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${npmrepo}/bin/npm-repo-proxy";
  };

  systemd.user.services.rss2email = {
    description = "run rss2email";
    path = with pkgs; [ rss2email ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.rss2email}/bin/r2e run";
  };

  systemd.user.services.backup-rss2email = {
    description = "backup rss2email";
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = pkgs.writeScript "backup-rss2email" ''
      #!${pkgs.bash}/bin/bash
      BACKUP_DIR=/home/jb55/backups/rss2email
      cp /home/jb55/.config/rss2email.cfg $BACKUP_DIR
      cp /home/jb55/.local/share/rss2email.json $BACKUP_DIR
      cd $BACKUP_DIR
      ${pkgs.git}/bin/git add -u
      ${pkgs.git}/bin/git commit -m "bump"
      ${pkgs.git}/bin/git push
    '';
  };

  systemd.user.timers.backup-rss2email = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "daily";
  };

  systemd.user.timers.rss2email = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "hourly";
  };

  systemd.services.hearpress = {
    description = "Hearpress server";
    wantedBy = [ "multi-user.target" ];
    after = [ "postgresql.service" ];

    environment = {
      PG_CS = "postgresql://jb55@localhost/hearpress";
      AWS_ACCESS_KEY_ID = extra.private.aws.access_key;
      AWS_SECRET_ACCESS_KEY = extra.private.aws.secret_key;
    };

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${hearpress}/bin/hearpressd";
  };

  services.dnsmasq.enable = false;
  services.dnsmasq.servers = ["8.8.8.8" "8.8.4.4"];
  services.dnsmasq.extraConfig = ''
    addn-hosts=${adblock-hosts}
    conf-file=${dnsmasq-adblock}
  '';

  security.setuidPrograms = [ "sendmail" ];

  services.fcgiwrap.enable = true;
  services.nginx.httpConfig = ''
    ${gitCfg}
  '';

}
