#!/bin/bash

# Variables para la base de datos
DB_NAME="proyecto"
DB_USER="proyecto_user"
DB_PASSWORD="666"
DB_HOST="localhost"

# Nombre del archivo de dump
DUMP_FILE="backup.sql"

# Asegurarse de que el script sea ejecutado como root o con permisos de superusuario
if [ "$(id -u)" -ne "0" ]; then
    echo "Este script necesita ser ejecutado como root o con permisos de superusuario."
    exit 1
fi

# Paso 1: Crear la base de datos y el usuario
echo "Creando la base de datos '$DB_NAME' y el usuario '$DB_USER'..."

# Crear la base de datos
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# Crear el usuario y asignar permisos
mysql -u root -p -e "CREATE USER IF NOT EXISTS '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';"
mysql -u root -p -e "FLUSH PRIVILEGES;"

echo "Base de datos y usuario creados con éxito."

# Paso 2: Crear un dump de la base de datos
echo "Haciendo el dump de la base de datos '$DB_NAME' en el archivo '$DUMP_FILE'..."

mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$DUMP_FILE"

if [ $? -eq 0 ]; then
    echo "Dump realizado con éxito."
else
    echo "Error al hacer el dump."
    exit 1
fi

# Paso 3: Instalar las dependencias de Python
echo "Instalando las dependencias de Python desde requirements.txt..."

if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "No se encontró el archivo requirements.txt."
    exit 1
fi

echo "Dependencias de Python instaladas correctamente."

# Paso 4: Iniciar el servidor Flask (si quieres también puedes descomentar esto)
# export FLASK_APP=app.py
# flask run --host=0.0.0.0

echo "Todo el proceso se completó con éxito."
echo "Puede ejecutar el software con el siguiente comando: ./run.sh"

exit 0
