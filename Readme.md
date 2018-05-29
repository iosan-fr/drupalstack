Drupal Stack
============

Everything is available thanks to `make` commands.

* `make up`: Launch containers
* `make stop`: Stop containers
* `make prune`: Remove containers
* `make ps`: See current containers launched
* `make shell`: Access to bash on PHP container
* `make drush`: Launch drush command
* `make logs`: Show logs
* `make composer`: Launch composer command
* `make site-install`: Install site
* `make site-update`: Update site
* `make build`: Rebuild containers
* `make xdebug-enable`: Enable xdebug
* `make xdebug-disable`: Disable xdebug
* `make xdebug-install`: Install xdebug

# For development

## First installation

Edit `.env` file and change `COMPOSE_PROJECT_NAME` for your own project name.

```
make build
make up
```

Then launch Drupal installation.

## Drupal Installation

Add ```prod``` after the command for prod mode. By default, dev is considered:
```
make site-install prod
```
In dev mode (default), installation will override admin password by admin and will provide dev environment and tools. Credentials are:
```
admin:admin
```

## Drupal Update

Add ```prod``` after the command for production. By default, dev is considered:
```
make site-update prod
```

### Errors solutions

In case you have an issue about system.site uuid, copy uuid from your
system.site.yml file then paste it in the command below

```
make drush config-set "system.site" uuid "[uuid]"
```

In case you have the following issue during update, this means the default
language uuid is different in database that from config files:

```
Synchronisation de la configuration : create language.entity.en.     [ok]
Drupal\language\Exception\DeleteDefaultLanguageException: Can not    [error]
delete the default language in
/var/www/html/web/core/modules/language/src/Entity/ConfigurableLanguage.php:155
Stack trace:
#0
/var/www/html/web/core/lib/Drupal/Core/Entity/EntityStorageBase.php(357):
Drupal\language\Entity\ConfigurableLanguage::preDelete(Object(Drupal\Core\Config\Entity\ConfigEntityStorage),
Array)
```

To fix this, copy the uuid from your language.entity.[default].yml file and
paste it in command:

```
make drush config-set "language.entity.fr" uuid "[uuid]"
```

# Access to the website

Put the following line in your /etc/hosts file (replace lequipetech.localhost by your own domain):

```
127.0.0.1 lequipetech.localhost
```

Go to http://lequipetech.localhost

# Development tools
## Xdebug
### Start and stop xdebug

Xdebug is included and disabled by default. To enable it:

```make xdebug-enable```

For performance reasons, it's advised to disable xdebug when you don't need it.

```make xdebug-disable```

If Xdebug is not installed:

```make xdebug-install```

### Xdebug in browser

Depending of your browser, launch xdebug plugin/extension.

### Phpstorm

1. In Phpstorm menu > Preferences > Languages & Frameworks > PHP > Debug
  * Set `Debug Port` to `9001`
  * Set Simultaneous connection to `8`
2. Then go to Run menu > Edit configurations.
  * Click on `+`
  * Select `PHP Remote Rebug`
  * Choose a name, like `Xdebug`
  * Apply and OK
3. When you need xdebug, click on the phone button to listen xdebug connections.
