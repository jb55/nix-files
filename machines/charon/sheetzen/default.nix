extra:
{ config, lib, pkgs, ... }:
let port = "1080";
    sname = "sheetzen.com";
    sheetzen = (import (pkgs.fetchzip {
      url    = "https://jb55.com/s/88985bb218b54734.tgz";
      sha256 = "16pa11g2na9pgj7ici69yci4hlr1zh3nvpnx4ipcj0w19ylw926l";
    }) {});
in
{
  services.nginx.httpConfig = lib.mkIf config.services.nginx.enable ''
    server {
      listen 80;
      server_name ${sname} www.${sname};

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      location / {
        return 301 https://${sname}$request_uri;
      }
    }

    server {
      listen 443 ssl;
      server_name ${sname};
      root ${sheetzen}/share/sheetzen/frontend;
      index index.html;

      ssl_certificate /var/lib/acme/${sname}/fullchain.pem;
      ssl_certificate_key /var/lib/acme/${sname}/key.pem;

      location = / {
        try_files index.html /index.html;
      }

      location / {
        try_files $uri $uri/ @proxy;
      }

      location @proxy {
        proxy_pass  http://localhost:${port};
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;
        proxy_buffering off;
        proxy_intercept_errors on;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      }

    }
  '';

  systemd.services.sheetzen = {
    enable = true;

    description = "sheetzen";

    wantedBy = [ "multi-user.target" ];
    after    = [ "postgresql.target" ];

    environment = {
      PGHOST = "127.0.0.1";
      PGPORT = "5432";
      PGUSER = "jb55";
      PGPASS = "";
      PGDATABASE = "sheetzen";
      ENV = "Production";
      JWT_KEYFILE = "${sheetzen}/share/sheetzen/credentials/token-key.json";
      CREDENTIAL_PATH = "${sheetzen}/share/sheetzen/credentials/SocialTracker.json";
      PORT = "${port}";
    };

    serviceConfig.ExecStart = "${sheetzen}/bin/sheetzend";
    unitConfig.OnFailure = "systemd-failure-emailer@%n.service";
  };
}
