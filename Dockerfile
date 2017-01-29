FROM alpine:edge

ENV CONSUL_TEMPLATE_VERSION=0.18.0

COPY consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS /usr/local/bin/consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS

RUN \
  echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --update-cache rspamd@testing rspamd-controller@testing \
  ca-certificates curl unzip rspamd-client@testing postgresql-client \

  && cd /usr/local/bin \
  && curl -L https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && sha256sum -c consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS \
  && unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS \

  && apk del curl unzip \
  && rm -rf /var/cache/apk/*

COPY logging.inc.template /etc/rspamd/override.d/logging.inc
COPY options.inc.template /etc/rspamd/override.d/options.inc
COPY dcc.conf.template /root/dcc.conf.template
COPY rspamd_start.sh /usr/local/bin/rspamd_start.sh
COPY rspamd.hcl /etc/rspamd.hcl
COPY pgpass.template /root/pgpass.template
COPY learn.template /root/learn.template
COPY worker-controller.inc.template /root/worker-controller.inc.template
COPY redis.conf.template /root/redis.conf.template
COPY greylist.conf.template /etc/rspamd/modules.d/greylist.conf

ENV USER_UID=1000
ENV USER_GID=1000

ENV RSPAMD_SERVICE=

CMD consul-template -config /etc/rspamd.hcl
