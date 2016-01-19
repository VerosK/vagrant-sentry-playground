# Class: sentry::params
#
# This class defines default parameters used by the main module class sentry
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to sentry class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#

class sentry::params (
  /* rpm package name*/
  $rpm_package      = "sentry",

  $http_port        = '80',
  /* secret code used for config */
  $secretcode       = undef,

  /* UNIX user */
  $user             = 'sentry',
  $group            = 'sentry',
  $home             = '/opt/sentry',
  /* db config */
  $db_driver        = 'postgres',
  $db_dbname        = 'sentry',
  $db_user          = 'sentry',
  $db_host          = 'localhost',
  $db_password      = 'sentry',
  /* redis config */
  $redis_config     = undef,
  $celery_workers = $::processorcount,
){
}

