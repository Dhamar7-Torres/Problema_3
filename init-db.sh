# Indica que el script debe ser interpretado utilizando el shell de bash.
#!/bin/bash

# Inicia un bucle que continúa ejecutándose mientras el comando mysqladmin 
# ping no responda, indicando que el servidor MySQL aún no está listo.
while ! mysqladmin ping -silent; do
    # Hace que el script espere 1 segundo antes de volver a comprobar el estado del servidor MySQL.
    sleep 1
# Marca el final del bucle while.
done

# Ejecuta un comando SQL que crea una base de datos llamada myapp si no existe.
mysql -e "CREATE DATABASE IF NOT EXISTS myapp;"

# Crea un usuario MySQL llamado myuser con la contraseña mypassword si no existe.
mysql -e "CREATE USER IF NOT EXISTS 'myuser'@'%' IDENTIFIED BY 'mypassword';"

# Otorga todos los privilegios en la base de datos myapp al usuario Myuser.
mysql -e "GRANT ALL PRIVILEGES ON myapp.* TO 'myuser'@'%';"

# Recarga las tablas de privilegios, haciendo efectivos los cambios.
mysql -e "FLUSH PRIVILEGES;"

# Básicamente, este script espera a que el servidor MySQL esté listo y luego configura una 
# base de datos y un usuario con los privilegios adecuados.