#!/bin/bash

# Variables para la base de datos
DB_NAME="proyecto"
DB_USER="proyecto_user"
DB_PASSWORD="666"
DB_HOST="localhost"
MYSQL_ROOT_PASSWORD="tu_contraseña_de_root"  # Cambia esto a tu contraseña de root

# Nombre del archivo de dump
DUMP_FILE="DumpGeneral.sql"

# Archivos adicionales para triggers, procedimientos y vistas
PROCEDURES_FILE="SQL/Procedimientos.sql"
TRIGGERS_FILE="SQL/Triggers.sql"
VIEWS_FILE="SQL/views.sql"

# Asegurarse de que el script sea ejecutado como root o con permisos de superusuario
if [ "$(id -u)" -ne "0" ]; then
    echo "Este script necesita ser ejecutado como root o con permisos de superusuario."
    exit 1
fi

# Paso 1: Crear la base de datos y el usuario
echo "Creando la base de datos '$DB_NAME' y el usuario '$DB_USER'..."

# Iniciar sesión en MySQL como root y ejecutar múltiples comandos
mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
    CREATE DATABASE IF NOT EXISTS $DB_NAME;
    CREATE USER IF NOT EXISTS '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWORD';
    GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';
    FLUSH PRIVILEGES;
EOF

echo "Base de datos y usuario creados con éxito."

# Paso 2: Restaurar el dump de la base de datos junto a los procedimientos, triggers y vistas
echo "Restaurando el dump de la base de datos '$DB_NAME' desde el archivo '$DUMP_FILE'..."

mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$DUMP_FILE"

if [ $? -eq 0 ]; then
    echo "Dump restaurado con éxito."
else
    echo "Error al restaurar el dump."
    exit 1
fi

# Paso 2.1: Restaurar procedimientos almacenados
if [ -f "$PROCEDURES_FILE" ]; then
    echo "Restaurando procedimientos almacenados desde '$PROCEDURES_FILE'..."
    mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$PROCEDURES_FILE"
    if [ $? -eq 0 ]; then
        echo "Procedimientos almacenados restaurados con éxito."
    else
        echo "Error al restaurar procedimientos almacenados."
        exit 1
    fi
else
    echo "No se encontró el archivo '$PROCEDURES_FILE'."
fi

# Paso 2.2: Restaurar triggers
if [ -f "$TRIGGERS_FILE" ]; then
    echo "Restaurando triggers desde '$TRIGGERS_FILE'..."
    mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$TRIGGERS_FILE"
    if [ $? -eq 0 ]; then
        echo "Triggers restaurados con éxito."
    else
        echo "Error al restaurar triggers."
        exit 1
    fi
else
    echo "No se encontró el archivo '$TRIGGERS_FILE'."
fi

# Paso 2.3: Restaurar vistas
if [ -f "$VIEWS_FILE" ]; then
    echo "Restaurando vistas desde '$VIEWS_FILE'..."
    mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$VIEWS_FILE"
    if [ $? -eq 0 ]; then
        echo "Vistas restauradas con éxito."
    else
        echo "Error al restaurar vistas."
        exit 1
    fi
else
    echo "No se encontró el archivo '$VIEWS_FILE'."
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
# export FLASK_APP=app/app.py
# flask run --host=0.0.0.0

echo "Todo el proceso se completó con éxito."
echo "Puede ejecutar el software con el siguiente comando: ./run.sh"

exit 0
