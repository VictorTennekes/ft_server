# Container OS
FROM debian:buster

# Fetching packages and installing
RUN apt update && \
    apt -y upgrade && \
    apt install -y nginx mariadb-server php7.3-fpm php-mysql php-common php-mbstring vim unzip wget

# Downloading the latest version of Wordpress
RUN wget -c https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    chmod -R 755 wordpress && \
    mv wordpress/* var/www/html && \
    rm latest.zip

# Downloading the latest version of phpMyAdmin
RUN wget  -c https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-all-languages.zip && \
    unzip phpMyAdmin-4.9.4-all-languages.zip && \
    mv phpMyAdmin-4.9.4-all-languages /var/www/html/phpmyadmin && \
    rm phpMyAdmin-4.9.4-all-languages.zip

# RUN rm -rf /etc/nginx/sites-enabled/*
# Copying the wordpress configuration to the container
COPY srcs/wp-config.php /var/www/html/wp-config.php
COPY config/default.conf /etc/nginx/sites-available/default
COPY config/php.ini /etc/php/7.3/fpm/php.ini

RUN rm -rf /var/www/html/index.php
RUN echo "Hello Victor" > /var/www/html/index.php
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Commands for starting the container
CMD service mysql start && \
    service php7.3-fpm start && \
    service nginx start && \
#    nginx -g "daemon off;" && \
    bash