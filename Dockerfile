# Container OS
FROM    debian:buster

# Fetching packages and installing
RUN     apt update && \
        apt -y upgrade && \
        apt install -y nginx mariadb-server php7.3-fpm php-mysql php-common php-mbstring vim unzip wget

RUN rm -rf /usr/share/nginx/www

# Nginx setup
RUN     mkdir -p /var/www/localhost
COPY    srcs/nginx-host-conf /etc/nginx/sites-available/localhost
RUN     ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled
RUN     echo "<?php echo 'Current PHP version: ' . phpversion(); ?>" > /var/www/localhost/index.php

# Creating the mysql database
RUN     service mysql start; \
        # mysql -uroot mysql; \
        # mysqladmin password "password"; \
        echo "CREATE DATABASE wordpress;" | mysql -u root; \
        echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'password';" | mysql -u root; \
        # echo "ALTER USER 'wordpress'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';" \
        echo "FLUSH PRIVILEGES" | mysql -u root

# Make folder for ssl
RUN     mkdir ssl-cert
COPY    srcs/localhost.cert /ssl-cert
COPY    srcs/localhost.key /ssl-cert

# Installing the latest version of Wordpress
RUN     wget -c https://wordpress.org/latest.zip && \
        unzip latest.zip && \
        mkdir -p /var/www/localhost/wordpress && \
        mv wordpress/* var/www/localhost/wordpress && \
        rm latest.zip

# Downloading the latest version of phpMyAdmin
RUN     wget  -c https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-english.tar.gz && \
        tar -xzvf phpMyAdmin-4.9.4-english.tar.gz && \
        mkdir -p /var/www/localhost/phpmyadmin && \
        mv -v phpMyAdmin-4.9.4-english/* /var/www/localhost/phpmyadmin && \
        chmod -R 755 /var/www/localhost/phpmyadmin

# RUN rm -rf /etc/nginx/sites-enabled/*
# Copying the wordpress configuration to the container
COPY    srcs/wp-config.php /var/www/localhost/wordpress/wp-config.php
COPY    srcs/config.inc.php /var/www/localhost/phpmyadmin
COPY    srcs/php.ini /etc/php/7.3/fpm/php.ini

# RUN rm -rf /var/www/html/index.php
# RUN echo "Hello Victor" > /var/www/html/index.php
# RUN rm /etc/nginx/sites-enabled/default
# RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Changing the accessibility of files
RUN		chown -R www-data:www-data /var/www/localhost/*
RUN		chmod -R 755 /var/www/localhost/*

# Commands for starting the container
CMD     service mysql start && \
        service php7.3-fpm start && \
        service nginx start && \
        # MYSQL_PWD=guest mysqld && \
        # nginx -g "daemon off;" && \
        bash