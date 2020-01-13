    -- granting all the privileges to  the user and making the wordpress database
    GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'password';
    -- GRANT ALL PRIVILEGES ON wordpress.* TO 'phpadmin'@'localhost' WITH GRANT OPTION;
    CREATE DATABASE wordpress;
    \q