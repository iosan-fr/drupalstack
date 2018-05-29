#!/bin/bash

echo ===========================================================
echo ===========================================================
echo     UPDATE drupal

if [[ "$1" == "prod" ]]; then
  composer install --no-dev --no-interaction
else
  # By default, dev update is made.
  composer install
fi

cd web

chmod 777 -R sites/default/files

../vendor/bin/drush state-set system.maintenance_mode 1

../vendor/bin/drush updb -y

# Update entity schema
../vendor/bin/drush entup -y

# Update configuration
../vendor/bin/drush cim -y

# Update entity migration if it's installed.
if [[ "`../vendor/bin/drush pm:list | grep entity_staging | grep Enabled`" != "" ]]; then
  # Update migration.
  ../vendor/bin/drush update-migration-config
  # Import content.
  ../vendor/bin/drush migrate:import --group=entity_staging
fi

../vendor/bin/drush state-set system.maintenance_mode 0

cd ..

echo ===========================================================
echo      UPDATE finished
echo ===========================================================

