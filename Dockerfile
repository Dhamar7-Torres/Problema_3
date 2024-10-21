# Define la imagen base de Docker a utilizar. En este caso, Ubuntu 20.04.
FROM ubuntu:20.04

# Establece una variable de entorno para evitar prompts interactivos durante la instalación de paquetes.
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza la lista de paquetes e instala los paquetes necesarios de manera no interactiva, incluidas las siguientes líneas:
RUN apt-get update && apt-get install -y \
    # para el servidor de Apache.
    apache2 \  
    # para el intérprete de PHP.
    php \
    # para la extensión de PHP que permite la interacción con MySQL.
    php-mysql \
    # para el servidor de bases de datos MySQL.
    mysql-server \
    # Limpia la caché de paquetes para reducir el tamaño de la imagen.
    && apt-get clean \
    # Elimina listas de paquetes descomprimidos, lo que también ayuda a reducir el tamaño de la imagen.
    && rm -rf /var/lib/apt/lists/*

# Habilita el módulo PHP para Apache.
RUN a2enmod php7.4

# Modifica la configuración de MySQL para permitir conexiones desde cualquier dirección IP.
RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Crea el directorio que contendrá los scripts de inicialización de bases de datos.
RUN mkdir -p /docker-entrypoint-initdb.d

# Copia un script de inicialización de bases de datos al contenedor.
COPY init-db.sh /docker-entrypoint-initdb.d/

# Otorga permisos de ejecución al script de inicialización de bases de datos.
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# Copia el contenido del directorio www del host al directorio web de Apache en el contenedor.
COPY www/ /var/www/html/

# Expone los puertos 80 (Apache) y 3306 (MySQL) del contenedor. EXPOSE prepara esos puertos para que puedan 
# ser mapeados desde el host al contenedor, facilitando la comunicación entre ellos y otros servicios
EXPOSE 80 3306

# Copia un script de inicio de servicios al directorio de binarios locales en el contenedor.
COPY start-services.sh /usr/local/bin/

# Otorga permisos de ejecución al script de inicio de servicios.
RUN chmod +x /usr/local/bin/start-services.sh

# Define el comando predeterminado que se ejecutará cuando se inicie el contenedor. En este caso, el script de inicio de servicios.
CMD ["/usr/local/bin/start-services.sh"]

# Este Dockerfile prepara un entorno para un servidor web con PHP y MySQL, con scripts de inicialización y servicios configurados