# Container OS
FROM debian:buster

# fetching the packages and installing
RUN apt update && \
        apt -y upgrade && \
        apt install -y nginx mariadb-server php7.3-fpm php-mysql wget vim unzip

# Downloading the latest wordpress files
RUN wget -c https://wordpress.org/latest.zip && \
        unzip latest.zip && \
        mv wordpress/* var/www/html && \
        rm latest.zip

# Downloading the latest phpMyAdmin
RUN wget -c https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-all-languages.zip && \
        unzip phpMyAdmin-4.9.4-all-languages.zip && \
        mv phpMyAdmin-4.9.4-all-languages /var/www/html/phpMyAdmin && \
        rm phpMyAdmin-4.9.4-all-languages.zip

# Copying necessary files to the container
COPY srcs/index.html /var/www/html
COPY srcs/index.php /var/www/html
COPY srcs/wp-config.php /var/www/html/wordpress
COPY srcs/wordpress.conf /etc/nginx/sites-available/
COPY db.sql ./

# Exposing a port
EXPOSE 80

# creating the mysql database
RUN service mysql start  && \
        echo "source db.sql" | mysql -u root -ppassword

# Commands for starting the container
CMD service nginx start && \
        service mysql start && \
        service php7.3-fpm start && \
        bash