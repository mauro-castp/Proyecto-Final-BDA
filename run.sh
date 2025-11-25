#!/bin/bash

# Agregar el directorio actual al PYTHONPATH
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
export FLASK_APP=app/app.py
export FLASK_ENV=development

echo "Iniciando la aplicación Flask..."
flask run --host=0.0.0.0