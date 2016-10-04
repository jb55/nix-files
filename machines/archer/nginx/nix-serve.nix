config:
let
    port = config.nix-serve.port;
    bind = config.ztip;
    localbind = config.nix-serve.bindAddress;
in ''
  server {
    listen ${bind}:80;
    server_name cache.zero.monster.cat;

    location / {
      proxy_pass  http://${localbind}:${toString port};
      proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
      proxy_redirect off;
      proxy_buffering off;
      proxy_set_header        Host            $host;
      proxy_set_header        X-Real-IP       $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    }
  }
''
