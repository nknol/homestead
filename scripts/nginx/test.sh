#!/usr/bin/env bash

block="server {
  listen *:80;
  server_name  $1;

  root $2;
  index opcache.php;

  location  ~ ^/(opcache)\.php(/|$) {
        fastcgi_param HTTPS off;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        fastcgi_param PATH_TRANSLATED \$document_root$fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME \$document_root$fastcgi_script_name;
        fastcgi_param APP_ENV dev;

        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;

        proxy_buffer_size 128k;
        proxy_buffers 4 256k;
        proxy_busy_buffers_size 256k;

        fastcgi_buffer_size 128k;
        fastcgi_buffers 4 256k;
        fastcgi_busy_buffers_size 256k;

        include fastcgi_params;
  }
  sendfile off;
}

"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
service nginx restart
service php5-fpm restart
