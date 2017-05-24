#!/usr/bin/env sh

userdel www-data 2>/dev/null
groupdel www-data 2>/dev/null
groupadd -g "$USER_GID" www-data
useradd -d /home/www-data -g www-data -u "$USER_UID" www-data

# docker permissions fix
rm -rf /var/dcc/log
mkdir -p /var/dcc/log

chown -R www-data:www-data /var/dcc

/var/dcc/libexec/rcDCC -m dccifd start &
child=$!

trap "kill $child" INT TERM
wait "$child"
