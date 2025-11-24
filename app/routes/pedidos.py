# routes/pedidos.py
from flask import Blueprint, jsonify, request, session
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required
import json

pedidos_bp = Blueprint('pedidos', __name__)

def init_pedidos_routes(app, mysql):
    @pedidos_bp.route('/api/pedidos', methods=['GET'])
    @login_required
    def obtener_pedidos():
        """Obtener todos los pedidos - vía procedimiento"""
        try:
            pagina = max(int(request.args.get('pagina', 1)), 1)
            limite = min(max(int(request.args.get('limite', 10)), 1), 50)
            estado = request.args.get('estado', '').strip()
            fecha = request.args.get('fecha', '').strip()

            offset = (pagina - 1) * limite

            cur = mysql.connection.cursor()
            cur.callproc('pedidosListar', [
                session['user_id'],
                session['user_role'],
                estado if estado else None,
                fecha if fecha else None,
                offset,
                limite
            ])
            pedidos = cur.fetchall()

            paginacion = {
                'total_registros': len(pedidos),
                'total_paginas': 1,
                'limite': limite,
                'offset_actual': offset
            }

            if cur.nextset():
                extra = cur.fetchone()
                if extra:
                    paginacion = {
                        'total_registros': extra.get('total_registros', len(pedidos)),
                        'total_paginas': max(1, extra.get('total_paginas', 1)),
                        'limite': extra.get('limite', limite),
                        'offset_actual': extra.get('offset_actual', offset)
                    }

            cur.close()

            cur_stats = mysql.connection.cursor()
            cur_stats.callproc('pedidosResumenEstados')
            estadisticas = cur_stats.fetchone() or {}
            cur_stats.close()

            total_paginas = max(1, paginacion['total_paginas'])

            return jsonify({
                'pedidos': pedidos,
                'paginacion': {
                    'pagina': pagina,
                    'limite': paginacion['limite'],
                    'total_paginas': total_paginas,
                    'total_registros': paginacion['total_registros']
                },
                'estadisticas': estadisticas
            })
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @pedidos_bp.route('/api/pedidos', methods=['POST'])
    @login_required
    @role_required([1, 2])
    def crear_pedido():
        """Crear nuevo pedido"""
        try:
            data = request.get_json()
            cur = mysql.connection.cursor()
            
            cur.callproc('pedidoCrear', [
                data['id_cliente'],
                data['id_direccion'],
                json.dumps(data['items'])
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': 'Pedido creado', 'id': result['id_pedido']})
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @pedidos_bp.route('/api/pedidos/<int:id>', methods=['GET'])
    @login_required
    def obtener_pedido(id):
        """Obtener pedido por ID vía procedimientos"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('pedidoObtener', [id])
            pedido = cur.fetchone()
            cur.close()

            if not pedido:
                return jsonify({'error': 'Pedido no encontrado'}), 404

            cur_detalle = mysql.connection.cursor()
            cur_detalle.callproc('pedidoDetalleObtener', [id])
            detalle = cur_detalle.fetchall()
            cur_detalle.close()
            pedido['detalles'] = detalle

            return jsonify(pedido)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @pedidos_bp.route('/api/pedidos/<int:id>/cancelar', methods=['POST'])
    @login_required
    @role_required([1, 2])
    def cancelar_pedido(id):
        """Cancelar pedido"""
        try:
            data = request.get_json()
            cur = mysql.connection.cursor()
            
            cur.callproc('pedidoCancelar', [
                id,
                data.get('motivo', 'Cancelado por el usuario')
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            if result['status'] == 'ok':
                return jsonify({'message': 'Pedido cancelado'})
            else:
                return jsonify({'error': 'No se puede cancelar el pedido en su estado actual'}), 400
                
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return pedidos_bp