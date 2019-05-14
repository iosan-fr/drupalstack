#!/bin/bash

echo ===========================================================
echo ===========================================================
echo     INSTALL drupal

if [[ "$1" == "prod" ]]; then
  composer install --no-dev --no-interaction
else
  # By default, dev installation is made.
  composer install
fi

composer drupal-scaffold

cd web

chmod 777 -R sites/default/files

if [[ "$1" != "prod" ]]; then
  php core/scripts/generate-proxy-class.php 'Drupal\webprofiler\Command\ListCommand' "modules/contrib/devel/webprofiler/src"
fi

../vendor/bin/drush site-install minimal -y --existing-config

# Re-init drupal console
../vendor/bin/drupal init --no-interaction --override --quiet

# Update entity migration if it's installed.
if [[ "`../vendor/bin/drush pm:list | grep entity_staging | grep Enabled`" != "" ]]; then
  # Update migration.
  ../vendor/bin/drush update-migration-config
  # Import content.
  ../vendor/bin/drush migrate:import --group=entity_staging
fi

if [[ "$1" != "prod" ]]; then
  ../vendor/bin/drush upwd admin admin
fi

cd ..

echo ===========================================================
echo      INSTALL finished
echo ===========================================================

