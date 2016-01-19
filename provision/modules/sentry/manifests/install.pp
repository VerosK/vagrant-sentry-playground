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
) {
  

  package{ $sentry::rpm_package:
    ensure => 'installed',
  }

  group { $sentry::group:
    ensure => 'present',
    system => true,
  }
  user{ $sentry::user:
    ensure     => 'present',
    groups     => [$sentry::group],
    system     => true,
    home       => $sentry::home,
    managehome => true,
  }
  file { $sentry::home:
    ensure  => 'directory',
    owner   => $sentry::user,
    group   => $sentry::group,
  }
  file { "${params::home}/.sentry":
    ensure => 'link',
    target => '/etc/sentry',
  }

  /* config files */
  file{"/etc/sentry/config.yml":
    owner   => $sentry::user,
    group   => $sentry::group,
    mode    => 600,
    content => template('sentry/config.yml.erb'),

    notify  => Exec["sentry::install: Init database"]
  }
  file{"/etc/sentry/sentry.conf.py":
    owner   => $sentry::user,
    group   => $sentry::group,
    mode    => 600,
    content => template('sentry/sentry.conf.erb'),

    notify  => Exec["sentry::install: Init database"]
  }

  /* create database */
  exec {"sentry::install: Init database":
    command => "/usr/bin/sentry upgrade --noinput" ,
    user => $sentry::user,
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
