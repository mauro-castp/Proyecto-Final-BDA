# routes/incidencias.py
from flask import Blueprint, jsonify, request, session
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required

incidencias_bp = Blueprint('incidencias', __name__)

def init_incidencias_routes(app, mysql):
    @incidencias_bp.route('/api/incidencias', methods=['GET'])
    @login_required
    def obtener_incidencias():
        """Obtener todas las incidencias"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("""
                SELECT i.*, z.nombre_zona, ti.nombre_tipo, ei.nombre_estado,
                       ni.nombre_nivel, u.nombre as nombre_reporta
                FROM incidencias i
                JOIN zonas z ON i.id_zona = z.id_zona
                JOIN tipos_incidencia ti ON i.id_tipo_incidencia = ti.id_tipo_incidencia
                JOIN estados_incidencia ei ON i.id_estado_incidencia = ei.id_estado_incidencia
                JOIN niveles_impacto ni ON i.id_nivel_impacto = ni.id_nivel_impacto
                LEFT JOIN usuarios u ON i.id_usuario_reporta = u.id_usuario
            """)
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
            cur = mysql.connection.cursor()
            
            cur.callproc('incidenciaRegistrar', [
                data['id_zona'],
                data['id_tipo_incidencia'],
                data['desde'],
                data.get('hasta')
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': 'Incidencia registrada', 'id': result['id_incidencia']})
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return incidencias_bp