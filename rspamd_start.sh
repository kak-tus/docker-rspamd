#!/usr/bin/env sh

deluser rspamd 2>/dev/null
delgroup rspamd 2>/dev/null
addgroup -g $USER_GID rspamd
adduser -h /home/rspamd -G rspamd -D -u $USER_UID rspamd

mkdir -p /run/rspamd
chown rspamd:rspamd /run/rspamd

mkdir -p /var/lib/rspamd
chown rspamd:rspamd /var/lib/rspamd

if [ "$RSPAMD_SERVICE" = "daemon" ]; then
  rspamd -f -u rspamd -g rspamd &
  child=$!
elif [ "$RSPAMD_SERVICE" = "cron" ]; then
  crond -f &
  child=$!
fi

trap "kill $child" SIGTERM SIGINT
wait "$child"
