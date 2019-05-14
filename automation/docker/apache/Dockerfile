FROM httpd:2.4

ARG WEB_USER
ARG WEB_GROUP
ARG PHP_HOST
ARG PHP_PORT
ARG DOCROOT_DIR
ARG APACHE_LOG_DIR
ARG APACHE_ROOT_DIR
ARG APACHE_SERVER_NAME

COPY ./etc/httpd.conf ${APACHE_ROOT_DIR}/conf/httpd.conf
COPY ./etc/httpd-vhosts.conf ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf

RUN mkdir -p ${DOCROOT_DIR}

RUN usermod -u 1000 ${WEB_USER} \
 && groupmod -g 1000 ${WEB_GROUP} \
 && chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR} \
 && chgrp -R ${WEB_GROUP} ${DOCROOT_DIR}

WORKDIR ${DOCROOT_DIR}