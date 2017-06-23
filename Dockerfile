FROM alpine:3.6

ENV CONSUL_TEMPLATE_VERSION=0.18.5
ENV CONSUL_TEMPLATE_SHA256=b0cd6e821d6150c9a0166681072c12e906ed549ef4588f73ed58c9d834295cd2

RUN \
  echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \

  && apk add --no-cache \
    ca-certificates \
    postgresql-client \
    rspamd-client@testing \
    rspamd-controller@testing \
    rspamd@testing \

  # && apk add --no-cache --virtual .build-deps \
  #   curl \
  #   unzip \
  && apk add --update-cache \
    curl \
    unzip \

  && cd /usr/local/bin \
  && curl -L https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && echo -n "$CONSUL_TEMPLATE_SHA256  consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" | sha256sum -c - \
  && unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \

  # Delete temporary disabled due to @testing warning
  # Try enable in alpine:3.7
  # && apk del .build-deps
  && apk del \
    curl \
    unzip \
  && rm -rf /var/cache/apk/*

COPY logging.inc.template /etc/rspamd/local.d/logging.inc
COPY options.inc.template /etc/rspamd/local.d/options.inc
COPY dcc.conf.template /root/dcc.conf.template
COPY rspamd_start.sh /usr/local/bin/rspamd_start.sh
COPY rspamd.hcl /etc/rspamd.hcl
COPY pgpass.template /root/pgpass.template
COPY learn.template /root/learn.template
COPY worker-controller.inc.template /root/worker-controller.inc.template
COPY redis.conf.template /root/redis.conf.template
COPY greylist.conf.template /etc/rspamd/modules.d/greylist.conf
COPY metrics.conf.template /etc/rspamd/local.d/metrics.conf
COPY mx_check.conf.template /etc/rspamd/modules.d/mx_check.conf
COPY worker-normal.inc.template /etc/rspamd/local.d/worker-normal.inc

ENV USER_UID=1000
ENV USER_GID=1000

ENV RSPAMD_SERVICE=

ENV CONSUL_HTTP_ADDR=
ENV CONSUL_TOKEN=
ENV VAULT_ADDR=
ENV VAULT_TOKEN=

EXPOSE 11333
EXPOSE 11334

CMD ["/usr/local/bin/consul-template", "-config", "/etc/rspamd.hcl"]
