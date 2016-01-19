
class sentry (
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
    /* number of celery workers */
    $celery_workers = $::processorcount,
) inherits sentry::params {

    class {"sentry::install":
    }
}