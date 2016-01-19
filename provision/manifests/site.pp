
notify{"Started on  ${fqdn}": }


Package {  allow_virtual => false }

# set default
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

exec{'Install sentry RPM': #
  command  => 'yum install -y /tmp/downloads/sentry-8.0.1-1.x86_64.rpm',
  creates  => '/opt/sentry/',

  before   => Class['sentry'],
}

class{ 'postgresql::server':
}

package{"redis":
  ensure => present,
  install_options => [ { '--enablerepo' => 'epel' } ],
}
service{"redis":
  ensure => running,
  enable => true,
  require => Package['redis'],
}


class{'sentry':
  db_dbname  => 'sentry',
}
postgresql::server::db { "Create sentry database":
  dbname   => $sentry::db_dbname,
  user     => $sentry::db_user,
  password => $sentry::db_password,
  encoding => 'UTF-8',

  before   => Class['sentry'],
}

service {"firewalld":
  ensure => stopped,
  enable => false,
}