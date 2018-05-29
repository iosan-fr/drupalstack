include .env

.PHONY: up down stop prune ps shell drush logs composer sh install update build

default: up

DRUPAL_ROOT ?= /var/www/html/web

up:
	@echo "Starting up containers for $(COMPOSE_PROJECT_NAME)..."
	docker-compose -f ${COMPOSE_FILE} stop reverse-proxy
	docker-compose -f ${COMPOSE_FILE} up -d --remove-orphans

pull:
	@echo "Pull down containers for $(COMPOSE_PROJECT_NAME)..."
	docker-compose -f ${COMPOSE_FILE} pull --parallel

down: stop

start: up

stop:
	@echo "Stopping containers for $(COMPOSE_PROJECT_NAME)..."
	@docker-compose -f ${COMPOSE_FILE} stop

prune:
	@echo "Removing containers for $(COMPOSE_PROJECT_NAME)..."
	@docker-compose -f ${COMPOSE_FILE} down -v

ps:
	@docker ps --filter name='$(COMPOSE_PROJECT_NAME)*'

shell:
	docker exec -ti $(COMPOSE_PROJECT_NAME)_php bash

ssh: shell

drush:
	docker exec -ti $(COMPOSE_PROJECT_NAME)_php vendor/bin/drush -r /var/www/html/web $(filter-out $@,$(MAKECMDGOALS))

logs:
	@docker-compose -f ${COMPOSE_FILE} logs -f $(filter-out $@,$(MAKECMDGOALS))

composer:
	docker exec -ti $(COMPOSE_PROJECT_NAME)_php composer $(filter-out $@,$(MAKECMDGOALS))

site-install:
	docker exec -ti $(COMPOSE_PROJECT_NAME)_php bash ./scripts/install.sh $(filter-out $@,$(MAKECMDGOALS))

site-update:
	docker exec -ti $(COMPOSE_PROJECT_NAME)_php bash ./scripts/update.sh $(filter-out $@,$(MAKECMDGOALS))

sh:
	docker exec -ti $(COMPOSE_PROJECT_NAME)_php bash $(filter-out $@,$(MAKECMDGOALS))

build:
	@echo "Rebuild containers $(COMPOSE_PROJECT_NAME)..."
	@docker-compose -f ${COMPOSE_FILE} build

xdebug-enable:
	docker exec -ti $(COMPOSE_PROJECT_NAME)_php mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.disabled /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
	@docker-compose -f ${COMPOSE_FILE} stop php
	@docker-compose -f ${COMPOSE_FILE} start php

xdebug-disable:
	docker exec -ti $(COMPOSE_PROJECT_NAME)_php mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.disabled
	@docker-compose -f ${COMPOSE_FILE} stop php
	@docker-compose -f ${COMPOSE_FILE} start php

xdebug-install:
	@echo "Install xdebug"
	@docker exec -ti $(COMPOSE_PROJECT_NAME)_php pecl install xdebug
	@docker cp ./docker/php/xdebug.ini drupal:/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
	@docker-compose -f ${COMPOSE_FILE} stop php
	@docker-compose -f ${COMPOSE_FILE} start php

# https://stackoverflow.com/a/6273809/1826109
%:
	@:
