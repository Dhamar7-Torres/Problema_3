# Indica que el script debe ser interpretado utilizando el shell de bash.
#!/bin/bash

# Inicia el servicio MySQL.
service mysql start

# Inicia un bucle for que itera sobre todos los archivos en el directorio /docker-entrypoint-initdb.d/.
for f in /docker-entrypoint-initdb.d/*; do
    # Inicia una declaración case para evaluar cada archivo.
    case "$f" in
        # Si el archivo tiene una extensión .sh, imprime un mensaje y ejecuta el archivo.
        *.sh)     echo "$0: running $f"; . "$f" ;;
        # Si el archivo no tiene una extensión .sh, imprime un mensaje indicando que el archivo es ignorado.
        *)        echo "$0: ignoring $f" ;;
    # Cierra la declaración case.
    esac
# Marca el final del bucle for.
done

# Inicia el servidor Apache en primer plano.
apache2ctl -D FOREGROUND

# En resumen, este script inicia el servicio MySQL, ejecuta cualquier script de inicialización en el
# directorio /docker-entrypoint-initdb.d/, y luego inicia el servidor Apache.