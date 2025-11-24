# routes/rutas.py
from flask import Blueprint, jsonify, request, session
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required
import json

rutas_bp = Blueprint('rutas', __name__)

def init_rutas_routes(app, mysql):
    @rutas_bp.route('/api/rutas', methods=['GET'])
    @login_required
    @role_required([1, 2])
    def obtener_rutas():
        """Obtener todas las rutas - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('rutasObtenerTodas')
            rutas = cur.fetchall()
            cur.close()
            return jsonify(rutas)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @rutas_bp.route('/api/rutas/<int:id>', methods=['GET'])
    @login_required
    @role_required([1, 2])
    def obtener_ruta(id):
        """Obtener ruta por ID - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('rutaObtenerPorId', [id])
            
            # Primer resultado: información de la ruta
            ruta = cur.fetchone()
            
            if not ruta:
                cur.close()
                return jsonify({'error': 'Ruta no encontrada'}), 404
            
            # Segundo resultado: paradas de la ruta
            if cur.nextset():
                paradas = cur.fetchall()
                ruta['paradas'] = paradas
            
            cur.close()
            return jsonify(ruta)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @rutas_bp.route('/api/rutas', methods=['POST'])
    @login_required
    @role_required([1, 2])
    def crear_ruta():
        """Crear nueva ruta - PROCEDIMIENTO EXISTENTE"""
        try:
            data = request.get_json()
            cur = mysql.connection.cursor()
            
            cur.callproc('rutaCrear', [
                data['id_zona'],
                data['fecha'],
                data['id_vehiculo'],
                data['id_repartidor'],
                json.dumps(data['secuencia'])
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': 'Ruta creada', 'id': result['id_ruta']})
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return rutas_bp