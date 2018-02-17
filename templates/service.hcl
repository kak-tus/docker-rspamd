max_stale = "2m"

template {
  source = "/root/templates/dcc.conf.template"
  destination = "/etc/rspamd/modules.d/dcc.conf"
}

template {
  source = "/root/templates/pgpass.template"
  destination = "/root/.pgpass"
  perms = 0600
}

template {
  source = "/root/templates/learn.template"
  destination = "/etc/periodic/daily/learn"
  perms = 0755
}

template {
  source = "/root/templates/worker-controller.inc.template"
  destination = "/etc/rspamd/local.d/worker-controller.inc"
}

template {
  source = "/root/templates/redis.conf.template"
  destination = "/etc/rspamd/local.d/redis.conf"
}

template {
  source = "/root/templates/logging.inc.template"
  destination = "/etc/rspamd/local.d/logging.inc"
}

template {
  source = "/root/templates/options.inc.template"
  destination = "/etc/rspamd/local.d/options.inc"
}

template {
  source = "/root/templates/greylist.conf.template"
  destination = "/etc/rspamd/modules.d/greylist.conf"
}

template {
  source = "/root/templates/metrics.conf.template"
  destination = "/etc/rspamd/local.d/metrics.conf"
}

template {
  source = "/root/templates/mx_check.conf.template"
  destination = "/etc/rspamd/modules.d/mx_check.conf"
}

template {
  source = "/root/templates/worker-normal.inc.template"
  destination = "/etc/rspamd/local.d/worker-normal.inc"
}

exec {
  command = "/usr/local/bin/rspamd_start.sh"
  splay = "60s"
}
