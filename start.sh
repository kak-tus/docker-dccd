#!/usr/bin/env sh

chown -R www-data:www-data /var/dcc

/var/dcc/libexec/rcDCC -m dccifd start &
child=$!

trap "kill $child" INT TERM
wait "$child"
