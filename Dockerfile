# Container OS
FROM    debian:buster

# Fetching packages and installing
RUN     apt update && \
        apt -y upgrade && \
        apt install -y nginx mariadb-server vim unzip wget sendmail && \
        apt install -y php7.3 php-mysql php-fpm php-cli php-mbstring php-curl php-gd php-intl php-soap php-xml php-xmlrpc php-zip

RUN apt install sudo

RUN rm -rf /usr/share/nginx/www

# Nginx setup
RUN     mkdir -p /var/www/localhost
COPY    srcs/nginx-host-conf /etc/nginx/sites-available/localhost
RUN     ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled

# Creating the mysql database
RUN     service mysql start; \
        echo "CREATE DATABASE wordpress;" | mysql -u root; \
        echo "GRANT ALL PRIVILEGES ON *.* TO 'vtenneke'@'localhost' IDENTIFIED BY 'password';" | mysql -u root; \
        echo "FLUSH PRIVILEGES" | mysql -u root

# Make folder for ssl
RUN     mkdir ssl-cert
COPY    srcs/localhost.cert /ssl-cert
COPY    srcs/localhost.key /ssl-cert


# Downloading the latest version of phpMyAdmin
RUN     wget  -c https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-english.tar.gz && \
        tar -xzvf phpMyAdmin-4.9.4-english.tar.gz && \
        mkdir -p /var/www/localhost/wordpress/phpmyadmin && \
        mv -v phpMyAdmin-4.9.4-english/* /var/www/localhost/wordpress/phpmyadmin && \
        chmod -R 755 /var/www/localhost/wordpress/phpmyadmin

# Copying the wordpress configuration to the container
COPY    srcs/config.inc.php /var/www/localhost/phpmyadmin
COPY    srcs/php.ini /etc/php/7.3/fpm/php.ini

# Downloading and installing WP-CLI
RUN chmod -R 755 /var/run/mysqld
RUN wget -c https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp
RUN wp cli update

# Making the wordpress directory and changing permissions
RUN mkdir -p /var/www/localhost/wordpress && \
    chmod a+rwx /var/www/localhost/wordpress 

# Adding user for running sudo commands
RUN adduser --disabled-password --gecos "" vtenneke
RUN sudo adduser vtenneke sudo

# Installing wordpress on the container
RUN service mysql start && \
sudo -u vtenneke wp core download --path=/var/www/localhost/wordpress&& \
sudo -u vtenneke wp config create --path=/var/www/localhost/wordpress --dbname=wordpress --dbuser=vtenneke --dbpass=password && \
sudo -u vtenneke wp core install --path=/var/www/localhost/wordpress --url=localhost --title="Victor's ft_server" --admin_name=vtenneke --admin_password=password --admin_email=victor@tennekes.nl && \
chmod 644 /var/www/localhost/wordpress/wp-config.php

# Changing the accessibility of files
RUN		chown -R www-data:www-data /var/www/localhost/*
RUN		chmod -R 755 /var/www/localhost/wordpress

# Removing the FTP prompt when installing themes and/or plugins
RUN sed -i "68i define('FS_METHOD','direct');" /var/www/localhost/wordpress/wp-config.php

EXPOSE 80 443 110

# Commands for starting the container
CMD     service mysql start && \
        service php7.3-fpm start && \
        service nginx start && \
        bash