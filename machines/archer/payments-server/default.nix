extra:
{ config, lib, pkgs, ... }:
let
  port = "8989";
  monstercatpkgs = import <monstercatpkgs> {};
  payments-server = monstercatpkgs.payments-server;
  payments-client = monstercatpkgs.payments-client;
in
{
  services.nginx.httpConfig = lib.mkIf config.services.nginx.enable ''
    server {
      listen 80;
      server_name payments.zero.monster.cat;
      root ${payments-client}/share;
      index index.html;

      location ^~ /api/ {
        proxy_pass  http://localhost:${port}/;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;
        proxy_buffering off;
        proxy_intercept_errors on;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      }

      location / {
        try_files $uri $uri /index.html;
      }
    }
  '';

  systemd.services.payments-server = {
    description = "Monstercat Payments Server";

    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "redis.service" "postgresql.service" ];

    environment = with extra.private; {
      POSTGRES_USER     = "jb55";
      POSTGRES_PASSWORD = "";
      POSTGRES_HOST     = "db.zero.monster.cat";
      POSTGRES_DATABASE = "Monstercat";
      REDIS_URL         = "redis://redis.zero.monster.cat:6379";
      PORT              = port;
      AWS_ACCESS_KEY    = aws_access_key;
      AWS_PRIVATE_KEY   = aws_secret_key;
      AWS_REGION        = aws_region;
      AWS_BUCKET        = aws_bucket;
    };

    serviceConfig.ExecStart = "${payments-server}/bin/payments-server";
    serviceConfig.Restart = "always";
    unitConfig.OnFailure = "notify-failed@%n.service";
  };
}
