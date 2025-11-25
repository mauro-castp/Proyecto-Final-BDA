# Proyecto Final - Base de Datos Avanzada

Aplicación web desarrollada con **Flask** y **MySQL** que implementa procedimientos almacenados, triggers y vistas.

## 🚀 Instalación Rápida

### Prerrequisitos
- **Python 3.9+**
- **MySQL Server**
- **Cliente MySQL**

### 1. Clonar el repositorio
```bash
git clone https://github.com/mauro-castp/Proyecto-Final-BDA.git
cd Proyecto-Final-BDA

### 2. Instalar dependencias de Python

pip install -r requirements.txt

### 3. Configurar la base de datos
mysql -u root -p

#### Ejecutar en MySQL:
CREATE DATABASE proyecto;
CREATE USER 'proyecto_user'@'localhost' IDENTIFIED BY '666';
GRANT ALL PRIVILEGES ON proyecto.* TO 'proyecto_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

####Importar la estructura y datos:
mysql -u root -p proyecto < SQL/backup.sql

####Importar procedimientos, triggers y vistas:
mysql -u root -p proyecto < SQL/Procedimientos.sql
mysql -u root -p proyecto < SQL/Triggers.sql
mysql -u root -p proyecto < SQL/views.sql

###4. Ejecutar la aplicación
python app/app.py