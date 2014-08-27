#!/usr/bin/env bash

block="server {
    listen *:80;

    server_name $1;

    root $2;

    location / {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root/index.php;
        fastcgi_param SCRIPT_NAME /index.php;
        fastcgi_param PATH_INFO \$uri;
    }

      location ~* ^.+\.(css|js|jpg|gif|png|txt|ico|swf|xml)$ {
          access_log off;
          root /vagrant/tools/beanstalkd/public;
          expires modified +90d;
      }

    sendfile off;
}

"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
service nginx restart
service php5-fpm restart
