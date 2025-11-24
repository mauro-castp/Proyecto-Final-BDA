# routes/entregas.py
from flask import Blueprint, jsonify, request, session
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required

entregas_bp = Blueprint('entregas', __name__)

def init_entregas_routes(app, mysql):
    @entregas_bp.route('/api/entregas', methods=['GET'])
    @login_required
    def obtener_entregas():
        """Obtener todas las entregas"""
        try:
            cur = mysql.connection.cursor()
            if session['user_role'] == 3:  # Repartidor
                cur.execute("""
                    SELECT e.*, p.id_pedido, c.nombre as nombre_cliente, 
                           ee.nombre_estado, r.nombre_ruta
                    FROM entregas e
                    JOIN pedidos p ON e.id_pedido = p.id_pedido
                    JOIN clientes c ON p.id_cliente = c.id_cliente
                    JOIN estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
                    LEFT JOIN rutas r ON e.id_ruta = r.id_ruta
                    WHERE e.id_repartidor = %s
                """, (session['user_id'],))
            else:
                cur.execute("""
                    SELECT e.*, p.id_pedido, c.nombre as nombre_cliente, 
                           ee.nombre_estado, r.nombre_ruta, u.nombre as nombre_repartidor
                    FROM entregas e
                    JOIN pedidos p ON e.id_pedido = p.id_pedido
                    JOIN clientes c ON p.id_cliente = c.id_cliente
                    JOIN estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
                    LEFT JOIN rutas r ON e.id_ruta = r.id_ruta
                    LEFT JOIN usuarios u ON e.id_repartidor = u.id_usuario
                """)
            entregas = cur.fetchall()
            cur.close()
            return jsonify(entregas)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    # ... (resto de las funciones de entregas)

    return entregas_bp