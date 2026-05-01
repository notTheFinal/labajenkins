#!/bin/sh

sed -i "s/{{ENV}}/${ENV}/g" /usr/share/nginx/html/index.html

exec nginx -g "daemon off;"