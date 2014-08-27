#!/usr/bin/env bash

block="server {
    listen *:80;

    server_name $1;

    root $2;

    location / {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root/genghis.php;
        fastcgi_param SCRIPT_NAME /genghis.php;
        fastcgi_param PATH_INFO \$uri;

        rewrite /genghis.php / permanent;
    }
    sendfile off;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
service nginx restart
service php5-fpm restart
