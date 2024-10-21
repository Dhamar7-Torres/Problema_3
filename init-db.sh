#!/bin/bash

# Esperamos a que MySQL esté listo
while ! mysqladmin ping -silent; do
    sleep 1
done

# Creamos un nuevo usuario y base de datos
mysql -e "CREATE DATABASE IF NOT EXISTS myapp;"
mysql -e "CREATE USER IF NOT EXISTS 'myuser'@'%' IDENTIFIED BY 'mypassword';"
mysql -e "GRANT ALL PRIVILEGES ON myapp.* TO 'myuser'@'%';"
mysql -e "FLUSH PRIVILEGES;"