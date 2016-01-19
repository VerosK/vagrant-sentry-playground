# = Class: zimbra
#
# This is the main zimbra class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# See README for usage patterns.
#
class sentry::install (
) inherits sentry::params {

  $params = $sentry::params

  package{ $params::rpm_package:
    ensure => 'installed',
  }

  group { $params::group:
    ensure => 'present',
    system => true,
  }
  user{ $params::user:
    ensure     => 'present',
    groups     => [$params::group],
    system     => true,
    home       => $params::home,
    managehome => true,
  }
  file { $params::home:
    ensure  => 'directory',
    owner   => $params::user,
    group   => $params::group,
  }
  file { "${params::home}/.sentry":
    ensure => 'link',
    target => '/etc/sentry',
  }

  /* config files */
  file{"/etc/sentry/config.yml":
    owner   => $params::user,
    group   => $params::group,
    mode    => 600,
    content => template('sentry/config.yml.erb'),

    notify  => Exec["sentry::install: Init database"]
  }
  file{"/etc/sentry/sentry.conf.py":
    owner   => $params::user,
    group   => $params::group,
    mode    => 600,
    content => template('sentry/sentry.conf.erb'),

    notify  => Exec["sentry::install: Init database"]
  }

  /* create database */
  exec {"sentry::install: Init database":
    command => "/usr/bin/sentry upgrade",
    user => $params::user,
    environment => 'SENTRY_CONF=/etc/sentry',

    refreshonly => true,
  }
  /* start services */
  file{ "sentry.service":
    path => "/etc/systemd/system/sentry.service",
    content => template('sentry/sentry.service.erb'),
  }
  service{"sentry":
    ensure => 'running',
    enable => true,

    require => File["sentry-celery.service"],
  }

  file{ "sentry-celery.service":
    path => "/etc/systemd/system/sentry-celery.service",
    content => template('sentry/sentry-celery.service.erb'),
  }
  service{"sentry-celery":
    ensure => 'running',
    enable => true,

    require => File["sentry-celery.service"],
  }
  file{ "sentry-celery-beat.service":
    path => "/etc/systemd/system/sentry-celery-beat.service",
    content => template('sentry/sentry-celery-beat.service.erb'),
  }
  service{"sentry-celery-beat":
    ensure => 'running',
    enable => true,

    require => File["sentry-celery-beat.service"],
  }
}
