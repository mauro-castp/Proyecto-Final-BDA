# Proyecto Final - Base de Datos Avanzada

Aplicación web desarrollada con **Flask** y **MySQL**, que utiliza procedimientos almacenados, triggers y vistas.

---

## 🧩 Requisitos

Antes de comenzar, asegúrate de tener instalado:

### 1. Python 3.9+
Verificar con:
```
python --version
```

### 2. MySQL Server (o MariaDB)
Verificar con:
```
mysql --version
```

### 3. Bash
- Linux y macOS ya lo incluyen.
- En Windows usar: Git Bash, WSL o Cygwin.

---

## 📁 Estructura del proyecto

```
app/
    routes/
    utils/
SQL/
    backup.sql
    Procedimientos.sql
    Triggers.sql
    views.sql
static/
    css/
    images/
    js/
templates/
requirements.txt
run.sh
setup_db.sh
```

---

## 🚀 Instalación y Configuración

### 1. Clonar repositorio

```
git clone <URL_DEL_REPOSITORIO>
cd <CARPETA_DEL_PROYECTO>
```

---

## 2. Configurar la base de datos automáticamente

El script **setup_db.sh** realiza:
- Creación de la base de datos
- Creación del usuario y permisos
- Restauración del dump inicial
- Importación de procedimientos, triggers y vistas
- Instalación de dependencias de Python

Ejecutar:
```
sudo ./setup_db.sh
```

Si no tiene permisos:
```
sudo chmod +x setup_db.sh
sudo ./setup_db.sh
```

Datos creados:
- Base de datos: `proyecto`
- Usuario: `proyecto_user`
- Contraseña: `666`

---

## 3. (Opcional) Crear entorno virtual

```
python -m venv venv
```

Activar:

Linux/Mac:
```
source venv/bin/activate
```

Windows:
```
venv\Scripts\activate
```

Instalar dependencias (si no se ejecutó setup_db.sh):
```
pip install -r requirements.txt
```

---

# ▶️ Ejecutar el servidor

Usar el script:
```
./run.sh
```

Si no tiene permisos:
```
chmod +x run.sh
./run.sh
```

Servidor disponible en:
http://localhost:5000

---

## 🌐 Ejecutar Flask manualmente

```
export FLASK_APP=app/app.py
flask run
```

---

## 📘 Documentación de la API

Disponible en:
http://localhost:5000/apidocs

---

## ❗ Problemas Comunes

**Error: "mysql: command not found"**
→ Instalar MySQL y agregar al PATH.

**Error: "Este script necesita ser ejecutado como root"**
→ Ejecutar con `sudo`.

**Errores importando triggers/procedimientos**
→ Revisar que los archivos existan en la carpeta `SQL/`.

---

## 👤 Contacto

Autor: **Juan José Carmona**
