#!/usr/bin/env bash

block="server {
    listen *:80;
    index redis-commander.js;
    server_name $1;
    root /home/vagrant/.npm/redis-commander/0.1.1/package/bin;
    location / {
        proxy_set_header X-Real-IP  \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header Host \$host;
        proxy_pass http://127.0.0.1:8081;
     }
     sendfile off;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
service nginx restart
