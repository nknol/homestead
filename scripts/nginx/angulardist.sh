#!/usr/bin/env bash

block="##########################
##   API BluePrint Mock  ##
###########################

server {
    listen *:80;
    server_name $1;
    location / {
        proxy_set_header X-Real-IP  \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header Host \$host;
        proxy_pass http://127.0.0.1:3000;

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
