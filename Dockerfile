FROM alpine:edge

RUN \
  echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --update-cache rspamd@testing ca-certificates \

  && mkdir /run/rspamd \
  && chown rspamd /run/rspamd \

  && rm -rf /var/cache/apk/*

COPY logging.inc.template /etc/rspamd/override.d/logging.inc
COPY options.inc.template /etc/rspamd/override.d/options.inc

CMD rspamd -f -u rspamd -g rspamd
