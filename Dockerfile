# Define la imagen base de Docker a utilizar. En este caso, Ubuntu 20.04.Esto para que se realice en el entorno de ubuntu
# aqui se especifica el sistema operativo y la versión en la que se creará el contenedor
FROM ubuntu:20.04

# Establece una variable de entorno para evitar prompts interactivos durante la instalación de paquetes.
# permite que todo se instale sin que se detenga esperando una respuesta por parte del usuario
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza la lista de paquetes e instala los paquetes necesarios de manera no interactiva, incluidas las siguientes líneas:
# RUN apt-get updateva a actualizar la lista de los paquetes que esten disponibleas, ""&&"" nos ejecutara
# el siguiente comando siempre y cuando el anterior haya tenido éxito y "apt-get install -y \" instalará los 
# paquetes especificos para el contenedor
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

# Con este código aseguramos que el servidor de Apache procese los archiivos de PHP
# para este dockerfile se usa la version de php 7.4, esto se hace para que se pueda configurar
# el entorno de un servidor web mediante php
RUN a2enmod php7.4

# Cambia la configuración de MySQL para que nuestro servidor pueda escuchar las interfaces que haya en la red
RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Crea el directorio que contendrá los archivos de inicialización de bases de datos.
# con esto aseguramos que nuestro directorio exista en el contenedor, en caso contrario de que no exista, lo que hará será crearlo
RUN mkdir -p /docker-entrypoint-initdb.d

# Esta linea va a copiar el archivo desde el directorio donde tenemos nuestro dockerfile de forma local y lo pegará 
# dentro del contenedor.
COPY init-db.sh /docker-entrypoint-initdb.d/

# Aquí lo que estamos haciendo es darle el poder de cambiar los permisos de nuestro archivo para que se vuelva ejecutable.
# esto le permitará ser ejecutado una vez se llame
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# Copia el contenido del directorio www del host al directorio web de Apache en el contenedor.
# esto se hace para que cualquier archivo HTML, CSS, etc, sea servido en Apache cuando se acceda al sitio web.
COPY www/ /var/www/html/

# Expone los puertos 80 (Apache) y 3306 (MySQL) del contenedor. EXPOSE prepara esos puertos para que puedan 
# ser mapeados desde el host al contenedor, facilitando la comunicación entre ellos y otros servicios
EXPOSE 80 3306

# Copia un archivo de inicio de servicios al directorio de binarios locales en el contenedor. El copy es la instrucción para copiar
# con el start-services.sh especificamos nuestro archivo de origen en el sistema de archivos del host y con el usr/local/bin/
# especificamos el directorio destimo en el sistema de archivos del contendor.
COPY start-services.sh /usr/local/bin/

# Igual que en el comando de más arriba, esto permite cambiar los persmisos del archivo start-services.shpara que sea ejecutable
# con el fin de que pueda ser ejecutado cuando sea llamado.
RUN chmod +x /usr/local/bin/start-services.sh

# Define el comando predeterminado que se ejecutará cuando se inicie el contenedor. En este caso, el archivo de inicio de servicios.
# una vez que el contenedor este listo, se ejecuta el archivo start-services.sh que esta ubicado en /usr/local/bin/.
CMD ["/usr/local/bin/start-services.sh"]

# Este Dockerfile prepara un entorno para un servidor web con PHP y MySQL, con archivos de inicialización y servicios configurados.