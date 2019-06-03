<?php

/**
 * @file
 * Local development override configuration feature.
 *
 * To activate this feature, copy and rename it such that its path plus
 * filename is 'sites/default/settings.local.php'. Then, go to the bottom of
 * 'sites/default/settings.php' and uncomment the commented lines that mention
 * 'settings.local.php'.
 *
 * If you are using a site name in the path, such as 'sites/example.com', copy
 * this file to 'sites/example.com/settings.local.php', and uncomment the lines
 * at the bottom of 'sites/example.com/settings.php'.
 */

/**
 * Assertions.
 *
 * The Drupal project primarily uses runtime assertions to enforce the
 * expectations of the API by failing when incorrect calls are made by code
 * under development.
 *
 * @see http://php.net/assert
 * @see https://www.drupal.org/node/2492225
 *
 * If you are using PHP 7.0 it is strongly recommended that you set
 * zend.assertions=1 in the PHP.ini file (It cannot be changed from .htaccess
 * or runtime) on development machines and to 0 in production.
 *
 * @see https://wiki.php.net/rfc/expectations
 */
assert_options(ASSERT_ACTIVE, TRUE);
\Drupal\Component\Assertion\Handle::register();

/**
 * Skip file system permissions hardening.
 *
 * The system module will periodically check the permissions of your site's
 * site directory to ensure that it is not writable by the website user. For
 * sites that are managed with a version control system, this can cause problems
 * when files in that directory such as settings.php are updated, because the
 * user pulling in the changes won't have permissions to modify files in the
 * directory.
 */
$settings['skip_permissions_hardening'] = TRUE;

# Settings.
$settings['container_yamls'][] = DRUPAL_ROOT . '/sites/development.services.yml';
$settings['cache']['default'] = 'cache.backend.null';
$settings['trusted_host_patterns'] = [
  '^' . getenv('DOMAIN') . '$',
  '^' . getenv('SITE_DOMAIN') . '$',
];
$settings['extension_discovery_scan_tests'] = FALSE;
$settings['rebuild_access'] = FALSE;
$settings['file_chmod_directory'] = 0775;
$settings['file_chmod_file'] = 0664;
$settings['hash_salt'] = 'aBs3EYjUnl9_pCyQR6qiEGekl_7o2ZdB_rSF9YxZ4OhYkhpOumt9xHxTaUnTZi_Zhfrm';
# Override config entities.
$config['system.logging']['error_level'] = 'verbose';
$config['system.performance']['css']['preprocess'] = TRUE;
$config['system.performance']['js']['preprocess'] = TRUE;
//$config['system.performance']['cache.page.max_age'] = 31536000;

// Additional module to enable during installation.
$settings['additional_modules'] = [
  'dblog',
  'devel',
  'field_ui',
  'kint',
  'vardumper',
  'vardumper_console',
  'views_ui',
  'webprofiler',
];

// Custom settings to ignore some configuration
// provided by modules on export.
$settings['config_export_blacklist_module'] = $settings['additional_modules'];

// Custom settings to ignore some configuration on export.
$settings['config_export_blacklist_config'] = [];

$databases['default']['default'] = array (
  'database' => getenv('MYSQL_DATABASE_DRUPAL'),
  'username' => getenv('MYSQL_USER_DRUPAL'),
  'password' => getenv('MYSQL_PASSWORD_DRUPAL'),
  'prefix' => '',
  'host' => getenv('MYSQL_HOST_DRUPAL'),
  'port' => getenv('MYSQL_PORT_DRUPAL'),
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
