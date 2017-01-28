max_stale = "2m"

template {
  source = "/root/dcc.conf.template"
  destination = "/etc/rspamd/modules.d/dcc.conf"
}

template {
  source = "/root/pgpass.template"
  destination = "/root/.pgpass"
  perms = 0600
}

template {
  source = "/root/learn.template"
  destination = "/etc/periodic/daily/learn"
  perms = 0755
}

exec {
  command = "/usr/local/bin/rspamd_start.sh"
  splay = "60s"
}
