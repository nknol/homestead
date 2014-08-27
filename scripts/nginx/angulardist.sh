#!/usr/bin/env bash

block="server {
      listen *:80;
      server_name $1;

      set \$host_path $2;
      root \$host_path;
      index index.html;

      # Re-route nested routes through index
      location / {
          try_files \$uri \$uri/ /index.html =404;
      }

      location ~* ^.+\.(css|js|jpg|gif|png|txt|ico|swf|xml)$ {
          access_log off;
          root $2;
      }

      sendfile off;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
service nginx restart
