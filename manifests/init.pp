
class vertx (
  $version      = "1.3.1.final",
  $dest         = "/usr/local/lib",
  $bindir       = "/usr/local/bin",
  $download_url = undef,
) {
  $libname = "vert.x-${version}"
  if !$download_url {
    $url = "http://vert-x.github.io/vertx-downloads/downloads/${libname}.tar.gz"
  } else {
    $url = $download_url
  }
  $instdir = "${dest}/${libname}"
  $buildpkgs = ["wget", "tar"]

  package { $buildpkgs:
    ensure => present,
  }

  exec {"download_and_untar":
    provider => shell,
    command  => "wget -qO- ${url} | tar xzf - -C /tmp",
    require  => Package[$buildpkgs],
  } ->

  file { $instdir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => "/tmp/${libname}",
  } ->

  file { "${bindir}/vertx":
    ensure  => link,
    target  => "${instdir}/bin/vertx",
  }

  user {"vertx":
    ensure => present,
    gid    => "vertx",
  }

  group {"vertx":
    ensure => present,
  }

  file { "/tmp/vertx.log":
    ensure => file,
    #owner  => "adcade",
    #group  => "adcade",
    mode   => 666,
  }
}
