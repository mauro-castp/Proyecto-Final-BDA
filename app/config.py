# config.py
import os

class Config:
    SECRET_KEY = 'clave-secreta-lum-2024-desarrollo'
    MYSQL_HOST = 'localhost'
    MYSQL_USER = 'proyecto_user'
    MYSQL_PASSWORD = '666'
    MYSQL_DB = 'proyecto'
    MYSQL_CURSORCLASS = 'DictCursor'
    MYSQL_CHARSET = 'utf8mb4'
    
    SWAGGER = {
        'title': 'LUM API - Logística Última Milla',
        'description': 'API completa para el sistema de logística de última milla',
        'version': '1.0.0',
        'uiversion': 3,
        'specs_route': '/api/docs/',
        'openapi': '3.0.0'
    }

swagger_template = {
    "openapi": "3.0.0",
    "info": {
        "title": "LUM API - Logística Última Milla",
        "description": "Documentación completa de la API del sistema de logística",
        "version": "1.0.0",
    },
    "host": "localhost:5000",
    "basePath": "/",
    "schemes": ["http", "https"],
}