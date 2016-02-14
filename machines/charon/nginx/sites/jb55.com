server {
  listen 443 ssl;
  server_name jb55.com;
  root /www/jb55/public;
  index index.html index.htm;

  ssl_certificate /etc/letsencrypt/live/jb55.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/jb55.com/privkey.pem;

  rewrite ^/pkgs.tar.gz$ https://github.com/jb55/jb55pkgs/archive/master.tar.gz permanent;
  rewrite ^/pkgs/?$ https://github.com/jb55/jb55pkgs/archive/master.tar.gz permanent;

  location / {
    try_files $uri $uri/ =404;
  }

  location ^~ /files/calls {
    error_page 405 =200 $uri;
  }
}

server {
  listen 80;
  server_name jb55.com;
  return 301 https://$server_name$request_uri;
}
