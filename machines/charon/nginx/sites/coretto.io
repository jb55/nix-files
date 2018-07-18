
server {
  listen 443 ssl;
  server_name coretto.io;
  root /www/jb55/public/coretto;
  index index.html;

  ssl_certificate /var/lib/acme/coretto.io/fullchain.pem;
  ssl_certificate_key /var/lib/acme/coretto.io/key.pem;

  location / {
    try_files $uri $uri/ =404;
  }

}

server {
  listen 80;
  server_name coretto.io www.coretto.io;

  location /.well-known/acme-challenge {
    root /var/www/challenges;
  }

  location / {
    return 301 https://coretto.io_uri;
  }
}

server {
  listen 443 ssl;
  server_name www.coretto.io;
  return 301 https://coretto.io$request_uri;
}