
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

class {"sentry::params":
  db_dbname  => 'sentry',
}

postgresql::server::db { "Create sentry database":
  dbname   => $sentry::params::db_dbname,
  user     => $sentry::params::db_user,
  password => $sentry::params::db_password,

  before   => Class['sentry'],
}

class{'sentry':

}