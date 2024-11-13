#!/bin/bash

# Para mostrar los comandos que se van ejecutando
set -ex

# Importamos las variables de entorno
source .env

# Eliminamos descargas previas de WP-CLI
rm -rf /tmp/wp-cli.phar

# Descargamos el WP-CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

# Le asignamos permisos de ejecución
chmod +x /tmp/wp-cli.phar

# Movemos el script WP-CLI al directorio /usr/local/bin
sudo mv /tmp/wp-cli.phar /usr/local/bin/wp

# Eliminamos instalaciones previas en /var/www/html
rm -rf /var/www/html/*

# Descargamos el código fuente de WordPress
wp core download --locale=es_ES --path=/var/www/html --allow-root

# Cambiamos el propietario y el grupo al directorio /var/www/html/
chown -R www-data:www-data /var/www/html/

# Creamos la base de datos y el usuario para WordPress
mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"