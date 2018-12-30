server {
  listen 443 ssl;
  server_name hearpress.com;
  root /www/hearpress.com/public;
  index index.html index.htm;

  ssl_certificate /var/lib/acme/hearpress.com/fullchain.pem;
  ssl_certificate_key /var/lib/acme/hearpress.com/key.pem;

  location @hearpress {
    proxy_pass http://localhost:3000$request_uri;
  }

  location / {
    try_files $uri $uri/ @hearpress;
    error_page 405 @hearpress;
  }

  location /blobs {
    resolver 8.8.8.8;
    proxy_pass https://hearpress.s3.amazonaws.com$request_uri;
  }
}

server {
  listen 80;
  server_name hearpress.com www.hearpress.com;

  location /.well-known/acme-challenge {
    root /var/www/challenges;
  }

  location / {
    return 301 https://hearpress.com$request_uri;
  }

}

server {
  listen 443 ssl;
  server_name www.hearpress.com;
  return 301 https://hearpress.com$request_uri;
}
