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

  ensure_resource("package", [$sentry::params::rpm_package],
      {'ensure' => 'installed'},
  )

  user{ $sentry::params::sentry_user:
    ensure => 'present',
    system => true,
  }
}
