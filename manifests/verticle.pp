define vertx::verticle (
  $verticle_name = $title,
  $run,
  $classpath = [],
  $user      = "vertx",
  $group     = "vertx",
  $logfile   = "/tmp/verticle.stdio",
  $XMS       = '256M',
  $XMX       = '1G',
  $XSS       = '2048K',
) {
  include stdlib

  if is_string($classpath) {
    $cp = [$classpath]
  } else {
    $cp = $classpath
  }

  file { "/etc/${verticle_name}.conf":
    ensure  => file,
    content => template("${module_name}/vertx.conf.erb"),
    notify  => Service[$verticle_name],
  }

  file { "/etc/init/${verticle_name}.conf":
    ensure  => file,
    content => template("${module_name}/vertx.init.erb"),
    notify  => Service[$verticle_name],
  }

  service { $verticle_name:
    ensure  => running,
    enable  => true,
    require => Class['vertx'],
  }
}
