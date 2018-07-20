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
      git = {projectroot = "/var/git";};
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

  users.extraGroups.jb55cert.members = [ "prosody" "nginx" ];

  services.gitDaemon.basePath = "/var/git-public/repos";
  services.gitDaemon.enable = true;

  security.acme.certs."jb55.com" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
    allowKeysForGroup = true;
    postRun = "systemctl restart prosody";
    email = myemail;
  };

  security.acme.certs."coretto.io" = {
    webroot = "/var/www/challenges";
    email = myemail;
  };

  security.acme.certs."git.jb55.com" = {
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

  users.extraUsers.prosody.extraGroups = [ "jb55cert" ];
  services.prosody.enable = true;
  services.prosody.admins = [ "jb55@jb55.com" ];
  services.prosody.allowRegistration = false;
  services.prosody.extraModules = [
    # "cloud_notify"
    # "smacks"
    # "carbons"
    # "http_upload"
  ];
  services.prosody.extraConfig = ''
    c2s_require_encryption = true
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
    dataDir = "/var/db/postgresql/9.5";
    #package = pkgs.postgresql95;
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

    server {
      listen 80;
      server_name git.jb55.com;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      location / {
        return 301 https://git.jb55.com$request_uri;
      }
    }

    server {
      listen       443 ssl;
      server_name  git.jb55.com;

      root /var/git-public/stagit;
      index index.html index.htm;

      ssl_certificate /var/lib/acme/git.jb55.com/fullchain.pem;
      ssl_certificate_key /var/lib/acme/git.jb55.com/key.pem;
    }

  '';

}
