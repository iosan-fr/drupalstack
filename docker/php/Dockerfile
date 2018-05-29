# from https://www.drupal.org/docs/8/system-requirements/drupal-8-php-requirements
FROM php:7.2-fpm

ARG WEB_USER
ARG WEB_GROUP
ARG DOCROOT_DIR

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# install the PHP extensions we need
RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		sendmail \
	; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-configure bcmath --enable-bcmath; \
	docker-php-ext-install -j "$(nproc)" \
	  bcmath \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=20000'; \
		echo 'realpath_cache_size=4096K'; \
		echo 'realpath_cache_ttl=600'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN set -ex; \
  \
  apt-get update; \
  apt-get install -y --no-install-recommends \
		git \
		vim \
		mariadb-client \
	;

RUN pecl install xdebug-2.6.0beta1 \
  && docker-php-ext-enable xdebug

RUN { \
		echo 'xdebug.default_enable = 1'; \
		echo 'xdebug.remote_enable = 1'; \
		echo 'xdebug.remote_handler = dbgp'; \
		echo 'xdebug.remote_port = 9001'; \
		echo 'xdebug.remote_autostart = 1'; \
		echo 'xdebug.remote_connect_back = 0'; \
		echo 'xdebug.remote_host = 10.254.254.254'; \
		echo 'xdebug.max_nesting_level = 256'; \
		echo 'upload_max_filesize = 15M'; \
		echo 'post_max_size = 15M'; \
	} >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.disabled

WORKDIR ${DOCROOT_DIR}