subdomain: port: ''
  server {
    listen 80;
    server_name ${subdomain}.jb55.com;
    return 301 https://${subdomain}.jb55.com$request_uri;
  }

  server {
    listen 443;
    server_name ${subdomain}.jb55.com;
    proxy_pass http://127.0.0.1:${port};
  }
''

