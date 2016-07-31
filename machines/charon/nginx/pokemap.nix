subdomain: port: ''
  server {
    listen 80;
    server_name ${subdomain}.jb55.com;
    root /www/jb55/public/maps;

    location /.well-known {
      try_files $uri $uri/ =404;
    }

    location / {
      return 301 https://${subdomain}.jb55.com$request_uri;
    }
  }

  server {
    listen 443;
    server_name ${subdomain}.jb55.com;

    ssl_certificate /etc/letsencrypt/live/${subdomain}.jb55.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${subdomain}.jb55.com/privkey.pem;

    location / {
      proxy_pass http://localhost:${port};
    }
  }

''
