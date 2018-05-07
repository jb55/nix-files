extra:
{ config, lib, pkgs, ... }:
let gitExtra = {
      git = {projectroot = "/var/git";};
      host = "git.razorcx.com";
    };
    gitCfg = extra.git-server { inherit config pkgs; extra = extra // gitExtra; };
    myemail = "will@razorcx.com";
    backendHost = "backend.razorcx.com";
in
{
  imports = [
    ./networking
    ./hardware
  ];

  networking.domain = backendHost;
  networking.search = [ backendHost ];
  networking.extraHosts = ''
    127.0.0.1 ${backendHost}
    ::1 ${backendHost}
  '';
  networking.firewall.allowedTCPPorts = [ 22 443 80 ];

  security.acme.certs."${backendHost}" = {
    webroot = "/var/www/challenges";
    email = myemail;
  };

  services.fcgiwrap.enable = true;
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

  #systemd.user.services.node-processor = {
  #  description = "node-processor";
  #  #path = with pkgs; [ nodeprocessor ];
  #  wantedBy = [ "default.target" ];
  #  serviceConfig.ExecStart = "${pkgs.rss2email}/bin/r2e run";
  #};

  # TODO: update to security programs
  #security.wrappers = {
  #  sendmail =
  #}

  services.nginx.enable = true;
  services.zerotierone.enable = true;

  services.nginx.httpConfig = ''
    ${gitCfg}

    server {
      listen 80;
      server_name ${backendHost};

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      location / {
        return 301 https://${backendHost}$request_uri;
      }
    }

    server {
      listen       443 ssl;
      server_name  ${backendHost};

      index index.html index.htm;

      ssl_certificate /var/lib/acme/${backendHost}/fullchain.pem;
      ssl_certificate_key /var/lib/acme/${backendHost}/key.pem;
    }

  '';

}
