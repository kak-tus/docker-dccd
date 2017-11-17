#!/usr/bin/env sh

groupadd -g "$USER_GID" user
useradd -d /home/user -g user -u "$USER_UID" user

# docker permissions fix
rm -rf /var/dcc/log
mkdir -p /var/dcc/log

chown -R user:user /var/dcc

/var/dcc/libexec/rcDCC -m dccifd start &
child=$!

trap "kill $child" INT TERM
wait "$child"
trap - INT TERM
wait "$child"
