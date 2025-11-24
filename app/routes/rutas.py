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
        """Obtener todas las rutas"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("""
                SELECT r.*, z.nombre_zona, u.nombre as nombre_repartidor,
                       v.placa, er.nombre_estado
                FROM rutas r
                JOIN zonas z ON r.id_zona = z.id_zona
                LEFT JOIN usuarios u ON r.id_repartidor = u.id_usuario
                LEFT JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo
                JOIN estados_ruta er ON r.id_estado_ruta = er.id_estado_ruta
            """)
            rutas = cur.fetchall()
            cur.close()
            return jsonify(rutas)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @rutas_bp.route('/api/rutas/<int:id>', methods=['GET'])
    @login_required
    @role_required([1, 2])
    def obtener_ruta(id):
        """Obtener ruta por ID"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("""
                SELECT r.*, z.nombre_zona, u.nombre as nombre_repartidor,
                       v.placa, er.nombre_estado
                FROM rutas r
                JOIN zonas z ON r.id_zona = z.id_zona
                LEFT JOIN usuarios u ON r.id_repartidor = u.id_usuario
                LEFT JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo
                JOIN estados_ruta er ON r.id_estado_ruta = er.id_estado_ruta
                WHERE r.id_ruta = %s
            """, (id,))
            ruta = cur.fetchone()
            
            cur.execute("""
                SELECT pr.*, p.id_pedido, c.nombre as nombre_cliente,
                       dc.direccion
                FROM paradas_ruta pr
                JOIN pedidos p ON pr.id_pedido = p.id_pedido
                JOIN clientes c ON p.id_cliente = c.id_cliente
                JOIN direcciones_cliente dc ON p.id_direccion_entrega = dc.id_direccion
                WHERE pr.id_ruta = %s
                ORDER BY pr.orden_secuencia
            """, (id,))
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
        """Crear nueva ruta"""
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