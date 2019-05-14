<?php

/**
 * @file
 * Install actions for the lequipetech_profile_demo profile.
 */

use Drupal\Core\Site\Settings;

/**
 * Implements hook_install_tasks().
 *
 * Drupal core forces update module to be installed by default, which we do not
 * want on a production setup.
 *
 * @see install_tasks()
 */
function lequipetech_profile_demo_install_tasks() {
  return [
    // This is an example of a task that defines a form which the user who is
    // installing the site will be asked to fill out. To implement this task,
    // your profile would define a function named myprofile_data_import_form()
    // as a normal form API callback function, with associated validation and
    // submit handlers. In the submit handler, in addition to saving whatever
    // other data you have collected from the user, you might also call
    // \Drupal::state()->set('myprofile.needs_batch_processing', TRUE) if the
    // user has entered data which requires that batch processing will need to
    // occur later on.
    'lequipetech_profile_demo_uninstall_update'          => [
      'display_name' => t('Uninstall update module for production.'),
      'type'         => 'normal',
    ],
    'lequipetech_profile_demo_enable_additional_modules' => [
      'display_name' => t('Enable additional modules'),
      'type'         => 'normal',
    ],
  ];
}

/**
 * Task callback for 'lequipetech_profile_demo_uninstall_update'.
 *
 * @see lequipetech_profile_demo_install_tasks()
 */
function lequipetech_profile_demo_uninstall_update() {
  /** @var \Drupal\Core\Extension\ModuleInstallerInterface $mi */
  $mi = \Drupal::service('module_installer');
  $mi->uninstall(['update'], TRUE);
}

/**
 * Task callback for 'niji_enable_additional_modules'.
 *
 * @see lequipetech_profile_demo_install_tasks()
 */
function lequipetech_profile_demo_enable_additional_modules() {
  $additional_modules = Settings::get('additional_modules');

  if (!empty($additional_modules)) {
    /** @var \Drupal\Core\Extension\ModuleInstaller $module_installer */
    $module_installer = \Drupal::service('module_installer');
    $module_installer->install($additional_modules);
  }
}
