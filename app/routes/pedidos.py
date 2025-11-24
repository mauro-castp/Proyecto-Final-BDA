# routes/pedidos.py (CRUD COMPLETO ACTUALIZADO)
from flask import Blueprint, jsonify, request, session
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required
import json
import logging

# Configurar logging
logger = logging.getLogger(__name__)

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
            id_empresa = request.args.get('empresa', '').strip()

            offset = (pagina - 1) * limite

            cur = mysql.connection.cursor()
            cur.callproc('pedidosListar', [
                session['user_id'],
                session['user_role'],
                estado if estado else None,
                fecha if fecha else None,
                id_empresa if id_empresa else None,
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
            logger.error(f"Error al obtener pedidos: {str(e)}")
            return jsonify({'error': 'Error al obtener pedidos'}), 500

    @pedidos_bp.route('/api/pedidos', methods=['POST'])
    @login_required
    @role_required([1, 2])
    def crear_pedido():
        """Crear nuevo pedido"""
        cur = None
        try:
            data = request.get_json()
            
            # Validaciones básicas
            if not data.get('id_cliente'):
                return jsonify({'error': 'El cliente es obligatorio'}), 400
            if not data.get('id_direccion'):
                return jsonify({'error': 'La dirección de entrega es obligatoria'}), 400
            if not data.get('items') or len(data.get('items', [])) == 0:
                return jsonify({'error': 'El pedido debe tener al menos un producto'}), 400

            cur = mysql.connection.cursor()
            cur.callproc('pedidoCrear', [
                data['id_cliente'],
                data['id_direccion'],
                data.get('id_empresa'),  # Nuevo parámetro
                json.dumps(data['items'])
            ])
            result = cur.fetchone()
            
            # IMPORTANTE: Consumir todos los resultados antes de commit
            while cur.nextset():
                pass
                
            mysql.connection.commit()
            cur.close()
            
            return jsonify({
                'message': 'Pedido creado exitosamente', 
                'id_pedido': result['id_pedido']
            }), 201
            
        except Exception as e:
            if cur:
                try:
                    while cur.nextset():
                        pass
                except:
                    pass
                mysql.connection.rollback()
                cur.close()
            logger.error(f"Error al crear pedido: {str(e)}")
            return jsonify({'error': 'Error al crear pedido'}), 500

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
            logger.error(f"Error al obtener pedido: {str(e)}")
            return jsonify({'error': 'Error al obtener pedido'}), 500

    @pedidos_bp.route('/api/pedidos/<int:id>', methods=['PUT'])
    @login_required
    @role_required([1, 2])
    def actualizar_pedido(id):
        """Actualizar pedido existente"""
        cur = None
        try:
            data = request.get_json()
            
            # Validaciones básicas
            if not data.get('id_estado_pedido'):
                return jsonify({'error': 'El estado del pedido es obligatorio'}), 400

            cur = mysql.connection.cursor()
            cur.callproc('pedidoActualizar', [
                id,
                data.get('id_estado_pedido'),
                data.get('motivo_cancelacion'),
                data.get('penalizacion_cancelacion', 0)
            ])
            result = cur.fetchone()
            
            # IMPORTANTE: Consumir todos los resultados antes de commit
            while cur.nextset():
                pass
                
            mysql.connection.commit()
            cur.close()

            if result and result.get('success') == 1:
                return jsonify({'message': 'Pedido actualizado exitosamente'})
            else:
                return jsonify({'error': 'No se pudo actualizar el pedido'}), 400
                
        except Exception as e:
            if cur:
                try:
                    while cur.nextset():
                        pass
                except:
                    pass
                mysql.connection.rollback()
                cur.close()
            logger.error(f"Error al actualizar pedido: {str(e)}")
            return jsonify({'error': 'Error al actualizar pedido'}), 500

    @pedidos_bp.route('/api/pedidos/<int:id>', methods=['DELETE'])
    @login_required
    @role_required([1, 2])
    def eliminar_pedido(id):
        """Eliminar pedido (solo si está en estado pendiente)"""
        cur = None
        try:
            cur = mysql.connection.cursor()
            cur.callproc('pedidoEliminar', [id])
            result = cur.fetchone()
            
            # IMPORTANTE: Consumir todos los resultados antes de commit
            while cur.nextset():
                pass
                
            mysql.connection.commit()
            cur.close()

            if result and result.get('success') == 1:
                return jsonify({'message': 'Pedido eliminado exitosamente'})
            else:
                return jsonify({'error': 'No se puede eliminar el pedido en su estado actual'}), 400
                
        except Exception as e:
            if cur:
                try:
                    while cur.nextset():
                        pass
                except:
                    pass
                mysql.connection.rollback()
                cur.close()
            logger.error(f"Error al eliminar pedido: {str(e)}")
            return jsonify({'error': 'Error al eliminar pedido'}), 500

    @pedidos_bp.route('/api/pedidos/<int:id>/cancelar', methods=['POST'])
    @login_required
    @role_required([1, 2])
    def cancelar_pedido(id):
        """Cancelar pedido"""
        cur = None
        try:
            data = request.get_json()
            cur = mysql.connection.cursor()
            
            cur.callproc('pedidoCancelar', [
                id,
                data.get('motivo', 'Cancelado por el usuario')
            ])
            result = cur.fetchone()
            
            # IMPORTANTE: Consumir todos los resultados antes de commit
            while cur.nextset():
                pass
                
            mysql.connection.commit()
            cur.close()
            
            if result['status'] == 'ok':
                return jsonify({'message': 'Pedido cancelado exitosamente'})
            else:
                return jsonify({'error': 'No se puede cancelar el pedido en su estado actual'}), 400
                
        except Exception as e:
            if cur:
                try:
                    while cur.nextset():
                        pass
                except:
                    pass
                mysql.connection.rollback()
                cur.close()
            logger.error(f"Error al cancelar pedido: {str(e)}")
            return jsonify({'error': 'Error al cancelar pedido'}), 500

    # ==================== ENDPOINTS PARA DATOS DE APOYO ====================

    @pedidos_bp.route('/api/pedidos/clientes-activos', methods=['GET'])
    @login_required
    def obtener_clientes_activos():
        """Obtener clientes activos para dropdown"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('clientesActivosListar')
            clientes = cur.fetchall()
            cur.close()
            return jsonify(clientes)
        except Exception as e:
            logger.error(f"Error al obtener clientes: {str(e)}")
            return jsonify({'error': 'Error al obtener clientes'}), 500

    @pedidos_bp.route('/api/pedidos/productos-activos', methods=['GET'])
    @login_required
    def obtener_productos_activos():
        """Obtener productos activos para dropdown"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('productosActivosListar')
            productos = cur.fetchall()
            cur.close()
            return jsonify(productos)
        except Exception as e:
            logger.error(f"Error al obtener productos: {str(e)}")
            return jsonify({'error': 'Error al obtener productos'}), 500

    @pedidos_bp.route('/api/pedidos/empresas-activas', methods=['GET'])
    @login_required
    def obtener_empresas_activas():
        """Obtener empresas activas para dropdown"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('empresasParaPedidos')
            empresas = cur.fetchall()
            cur.close()
            return jsonify(empresas)
        except Exception as e:
            logger.error(f"Error al obtener empresas: {str(e)}")
            return jsonify({'error': 'Error al obtener empresas'}), 500

    @pedidos_bp.route('/api/pedidos/zonas-activas', methods=['GET'])
    @login_required
    def obtener_zonas_activas():
        """Obtener zonas activas para dropdown"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('zonasActivasListar')
            zonas = cur.fetchall()
            cur.close()
            return jsonify(zonas)
        except Exception as e:
            logger.error(f"Error al obtener zonas: {str(e)}")
            return jsonify({'error': 'Error al obtener zonas'}), 500

    @pedidos_bp.route('/api/pedidos/cliente/<int:id_cliente>/direcciones', methods=['GET'])
    @login_required
    def obtener_direcciones_cliente(id_cliente):
        """Obtener direcciones de un cliente específico"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('clienteDireccionesListar', [id_cliente])
            direcciones = cur.fetchall()
            cur.close()
            return jsonify(direcciones)
        except Exception as e:
            logger.error(f"Error al obtener direcciones: {str(e)}")
            return jsonify({'error': 'Error al obtener direcciones del cliente'}), 500

    @pedidos_bp.route('/api/pedidos/estados', methods=['GET'])
    @login_required
    def obtener_estados_pedido():
        """Obtener todos los estados de pedido"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT id_estado_pedido, nombre_estado, descripcion FROM estados_pedido ORDER BY id_estado_pedido")
            estados = cur.fetchall()
            cur.close()
            return jsonify(estados)
        except Exception as e:
            logger.error(f"Error al obtener estados: {str(e)}")
            return jsonify({'error': 'Error al obtener estados de pedido'}), 500

    return pedidos_bp