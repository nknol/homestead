#!/usr/bin/env bash

block="server {
  listen   *:80;
  server_name $1;

  root $2;
  index index.php index.html index.htm;

  location / {
      try_files \$uri \$uri/ /index.php\$is_args\$args;
  }

  # pass the PHP scripts to FastCGI server listening on /var/run/php5-fpm.sock
  location ~ \.php$ {
      try_files \$uri /index.php =404;
      fastcgi_pass unix:/var/run/php5-fpm.sock;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
      include fastcgi_params;
      fastcgi_param APP_ENV dev;
      # http://tech.shift.com/post/65650561508/cors-with-wildcard-subdomains-using-nginx

      add_header Access-Control-Allow-Origin *;
      add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS, DELETE, PUT';
      add_header Access-Control-Allow-Credentials true;
      add_header Access-Control-Allow-Headers User-Agent,Keep-Alive,Content-Type,Authorization;
  }

  sendfile off;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
service nginx restart
service php5-fpm restart
