#!/bin/bash

# Script para configurar la base de datos
# Ejecuta el dump general, procedimientos, triggers y vistas
# LUM System - Logística Última Milla
# Compatible con CentOS

# No usar set -e aquí para permitir manejo manual de errores

# Configuración de la base de datos
DB_NAME="proyecto"
DB_USER="proyecto_user"
DB_PASS="666"
DB_HOST="localhost"

echo "=========================================="
echo "🗄️  Configurando Base de Datos LUM"
echo "=========================================="

# Cambiar al directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Verificar que MySQL/MariaDB está disponible
if ! command -v mysql &> /dev/null; then
    echo "❌ Error: mysql no está instalado o no está en el PATH"
    echo ""
    echo "   Para CentOS, instala MariaDB con:"
    echo "   sudo yum install mariadb mariadb-server"
    echo "   sudo systemctl start mariadb"
    echo "   sudo systemctl enable mariadb"
    exit 1
fi

echo "✅ Cliente MySQL/MariaDB encontrado"

# Verificar conexión a la base de datos
echo "🔍 Verificando conexión a la base de datos..."
export MYSQL_PWD="$DB_PASS"
if ! mysql -h "$DB_HOST" -u "$DB_USER" -e "USE $DB_NAME;" 2>/dev/null; then
    unset MYSQL_PWD
    echo "⚠️  Advertencia: No se pudo conectar a la base de datos"
    echo "   Verifica que:"
    echo "   1. El servicio MySQL/MariaDB esté ejecutándose"
    echo "   2. La base de datos '$DB_NAME' exista"
    echo "   3. El usuario '$DB_USER' tenga permisos"
    echo ""
    echo "   Comandos útiles para CentOS:"
    echo "   sudo systemctl status mariadb"
    echo "   sudo systemctl start mariadb"
    echo ""
    read -p "¿Deseas continuar de todas formas? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        unset MYSQL_PWD
        exit 1
    fi
    unset MYSQL_PWD
else
    unset MYSQL_PWD
    echo "✅ Conexión a la base de datos exitosa"
fi

# Función para ejecutar un archivo SQL
execute_sql() {
    local file=$1
    local description=$2
    
    if [ ! -f "$file" ]; then
        echo "❌ Error: No se encontró el archivo $file"
        return 1
    fi
    
    echo ""
    echo "📄 Ejecutando: $description"
    echo "   Archivo: $file"
    
    # Ejecutar con manejo de errores mejorado
    # Usar MYSQL_PWD para evitar mostrar la contraseña en el historial
    export MYSQL_PWD="$DB_PASS"
    if mysql -h "$DB_HOST" -u "$DB_USER" "$DB_NAME" < "$file" 2>&1; then
        unset MYSQL_PWD
        echo "✅ $description ejecutado correctamente"
        return 0
    else
        local exit_code=$?
        unset MYSQL_PWD
        echo "❌ Error al ejecutar $description (código: $exit_code)"
        echo "   Revisa el archivo $file para más detalles"
        return $exit_code
    fi
}

# Contador de errores
ERROR_COUNT=0

# 1. Ejecutar dump general (estructura y datos)
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1️⃣  Ejecutando Dump General..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if ! execute_sql "DumpGeneral.sql" "Dump General de la Base de Datos"; then
    ((ERROR_COUNT++))
    echo "⚠️  Continuando con los siguientes pasos..."
fi

# 2. Ejecutar procedimientos almacenados
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2️⃣  Ejecutando Procedimientos Almacenados..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if ! execute_sql "SQL/Procedimientos.sql" "Procedimientos Almacenados"; then
    ((ERROR_COUNT++))
    echo "⚠️  Continuando con los siguientes pasos..."
fi

# 3. Ejecutar triggers
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3️⃣  Ejecutando Triggers..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if ! execute_sql "SQL/Triggers.sql" "Triggers de Auditoría"; then
    ((ERROR_COUNT++))
    echo "⚠️  Continuando con los siguientes pasos..."
fi

# 4. Ejecutar vistas
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4️⃣  Ejecutando Vistas..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if ! execute_sql "SQL/views.sql" "Vistas de la Base de Datos"; then
    ((ERROR_COUNT++))
fi

# Resumen final
echo ""
echo "=========================================="
if [ $ERROR_COUNT -eq 0 ]; then
    echo "✅ Configuración de Base de Datos Completada"
    echo "=========================================="
    echo ""
    echo "📊 Base de datos: $DB_NAME"
    echo "👤 Usuario: $DB_USER"
    echo "🔗 Host: $DB_HOST"
    echo ""
    echo "🎉 ¡Base de datos lista para usar!"
    exit 0
else
    echo "⚠️  Configuración Completada con Errores"
    echo "=========================================="
    echo ""
    echo "📊 Base de datos: $DB_NAME"
    echo "👤 Usuario: $DB_USER"
    echo "🔗 Host: $DB_HOST"
    echo "❌ Errores encontrados: $ERROR_COUNT"
    echo ""
    echo "⚠️  Revisa los mensajes de error anteriores"
    exit 1
fi

