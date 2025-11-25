#!/bin/bash

# Variables para la base de datos
DB_NAME="proyecto"
DB_USER="proyecto_user"
DB_PASSWORD="666"
DB_HOST="localhost"

# Nombre del archivo de dump
DUMP_FILE="DumpGeneral.sql"

# Archivos adicionales para triggers, procedimientos y vistas
PROCEDURES_FILE="SQL/Procedimientos.sql"
TRIGGERS_FILE="SQL/Triggers.sql"
VIEWS_FILE="SQL/views.sql"

# Paso 1: Crear la base de datos y el usuario
echo "Creando la base de datos '$DB_NAME' y el usuario '$DB_USER'..."

# Eliminar la base de datos y usuario si existen
sudo mysql -e "DROP DATABASE IF EXISTS $DB_NAME;"
sudo mysql -e "DROP USER IF EXISTS '$DB_USER'@'$DB_HOST';"

# Crear la base de datos y usuario
sudo mysql -e "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWORD';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';"
sudo mysql -e "FLUSH PRIVILEGES;"

if [ $? -eq 0 ]; then
    echo "Base de datos y usuario creados con éxito."
else
    echo "Error al crear la base de datos o el usuario."
    exit 1
fi

# Paso 2: Restaurar el dump de la base de datos
echo "Restaurando el dump de la base de datos '$DB_NAME' desde el archivo '$DUMP_FILE'..."

if [ -f "$DUMP_FILE" ]; then
    mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$DUMP_FILE"
    
    if [ $? -eq 0 ]; then
        echo "Dump restaurado con éxito."
    else
        echo "Error al restaurar el dump."
        exit 1
    fi
else
    echo "No se encontró el archivo '$DUMP_FILE'."
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
    # Verificar si pip está disponible
    if command -v pip3 &> /dev/null; then
        pip3 install -r requirements.txt
    elif command -v pip &> /dev/null; then
        pip install -r requirements.txt
    else
        echo "Error: No se encontró pip o pip3 instalado en el sistema."
        exit 1
    fi
else
    echo "No se encontró el archivo requirements.txt."
    exit 1
fi

echo "Dependencias de Python instaladas correctamente."

echo "Todo el proceso se completó con éxito."
echo "Puede ejecutar el software con el siguiente comando: sudo ./run.sh"

exit 0