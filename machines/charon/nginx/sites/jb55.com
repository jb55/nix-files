server {
  listen 443 ssl;
  server_name jb55.com;
  root /www/jb55/public;
  index index.html index.htm;

  ssl_certificate /var/lib/acme/jb55.com/fullchain.pem;
  ssl_certificate_key /var/lib/acme/jb55.com/key.pem;

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
  server_name jb55.com www.jb55.com;

  location /.well-known/acme-challenge {
    root /var/www/challenges;
  }

  location / {
    return 301 https://jb55.com$request_uri;
  }
}

server {
  listen 443 ssl;
  server_name www.jb55.com;
  return 301 https://jb55.com$request_uri;
}
