#!/usr/bin/env sh

if [ "$RSPAMD_SERVICE" = "daemon" ]; then
  rspamd -f -u rspamd -g rspamd &
  child=$!
elif [ "$RSPAMD_SERVICE" = "cron" ]; then
  crond -f &
  child=$!
fi

trap "kill $child" SIGTERM SIGINT
wait "$child"
trap - SIGTERM SIGINT
wait "$child"
