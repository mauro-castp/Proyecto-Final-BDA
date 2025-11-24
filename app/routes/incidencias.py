# routes/incidencias.py
from flask import Blueprint, jsonify, request, session
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required

incidencias_bp = Blueprint('incidencias', __name__)

def init_incidencias_routes(app, mysql):
    @incidencias_bp.route('/api/incidencias', methods=['GET'])
    @login_required
    def obtener_incidencias():
        """Obtener todas las incidencias - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('incidenciasObtenerTodas')
            incidencias = cur.fetchall()
            cur.close()
            return jsonify(incidencias)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @incidencias_bp.route('/api/incidencias', methods=['POST'])
    @login_required
    @role_required([1, 2, 3])
    def crear_incidencia():
        """Crear nueva incidencia"""
        try:
            data = request.get_json()
            user_id = session.get('user_id', 1)
            
            cur = mysql.connection.cursor()
            
            cur.callproc('incidenciaRegistrar', [
                data['id_zona'],
                data['id_tipo_incidencia'],
                data['descripcion'],
                data['fecha_inicio'],
                data.get('fecha_fin'),
                data['id_nivel_impacto'],
                user_id,
                data.get('observaciones', '')
            ])
            
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            return jsonify({
                'message': 'Incidencia registrada correctamente', 
                'id': result['id_incidencia']
            })
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @incidencias_bp.route('/api/incidencias/<int:id>', methods=['PUT'])
    @login_required
    @role_required([1, 2, 3])
    def actualizar_incidencia(id):
        """Actualizar estado de incidencia"""
        try:
            data = request.get_json()
            
            cur = mysql.connection.cursor()
            cur.callproc('incidenciaActualizar', [
                id,
                data['id_estado_incidencia'],
                data.get('fecha_fin'),
                data.get('comentario', '')
            ])
            
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': result['mensaje']})
        except Exception as e:
            return jsonify({'error': str(e)}), 500