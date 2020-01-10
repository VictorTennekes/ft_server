    -- granting all the privileges to  the user and making the wordpress database
    GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'password';
    CREATE DATABASE wordpress;
    \q