#!/usr/bin/env sh

deluser rspamd 2>/dev/null
delgroup rspamd 2>/dev/null
addgroup -g $USER_GID rspamd
adduser -h /home/rspamd -G rspamd -D -u $USER_UID rspamd

mkdir -p /run/rspamd
chown rspamd:rspamd /run/rspamd

mkdir -p /var/lib/rspamd
chown rspamd:rspamd /var/lib/rspamd

/usr/local/bin/consul-template -config /root/templates/service.hcl &
child=$!

trap "kill -s SIGINT $child" SIGTERM SIGINT
wait "$child"
trap - SIGTERM SIGINT
wait "$child"
