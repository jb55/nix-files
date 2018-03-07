extra:
{ config, lib, pkgs, ... }:
let gitExtra = {
      git = {projectroot = "/var/git";};
      host = "git.razorcx.com";
    };
    gitCfg = extra.git-server { inherit config pkgs; extra = extra // gitExtra; };
    myemail = "will@razorcx.com";
in
{
  imports = [
    ./hardware
  ];

  networking.domain = "backend.razorcx.com";
  networking.search = [ "backend.razorcx.com" ];
  networking.extraHosts = ''
    127.0.0.1 backend.razorcx.com
    ::1 backend.razorcx.com
  '';
  networking.firewall.allowedTCPPorts = [ 22 143 80 ];

  security.acme.certs."backend.razorcx.com" = {
    webroot = "/var/www/challenges";
    group = "certs";
    allowKeysForGroup = true;
    email = myemail;
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/10/";
    enable = true;
    package = pkgs.postgresql100;
    authentication = ''
      # type db  user address        method
      local  all all                 trust
    '';
    #extraConfig = ''
    #  listen_addresses = '${extra.ztip}'
    #'';
  };

  systemd.services.npmrepo = {
    description = "npmrepo.com";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${npmrepo}/bin/npm-repo-proxy";
  };

  #systemd.user.services.node-processor = {
  #  description = "node-processor";
  #  #path = with pkgs; [ nodeprocessor ];
  #  wantedBy = [ "default.target" ];
  #  serviceConfig.ExecStart = "${pkgs.rss2email}/bin/r2e run";
  #};

  # TODO: update to security programs
  #security.setuidPrograms = [ "sendmail" ];

  services.nginx.httpConfig = ''
    ${gitCfg}

    server {
      listen 80;
      server_name backend.razorcx.com;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      location / {
        return 301 https://backend.razorcx.com$request_uri;
      }
    }

    server {
      listen       443 ssl;
      server_name  backend.jb55.com;

      index index.html index.htm;

      ssl_certificate /var/lib/acme/backend.razorcx.com/fullchain.pem;
      ssl_certificate_key /var/lib/acme/backend.razorcx.com/key.pem;
    }

  '';

}
