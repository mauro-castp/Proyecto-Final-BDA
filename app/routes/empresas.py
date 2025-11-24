# routes/empresas.py (ACTUALIZADO)
from flask import Blueprint, request, jsonify, session
from flask_mysqldb import MySQL
import MySQLdb
import logging

# Configurar logging
logger = logging.getLogger(__name__)

def init_empresas_routes(app, mysql):
    empresas_bp = Blueprint('empresas', __name__)

    @empresas_bp.route('/api/empresas', methods=['GET'])
    def obtener_empresas():
        """Obtener todas las empresas"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('obtenerEmpresas')
            empresas = cur.fetchall()
            cur.close()
            
            empresas_list = []
            for empresa in empresas:
                empresas_list.append({
                    'id_empresa': empresa['id_empresa'],
                    'nombre': empresa['nombre'],
                    'telefono': empresa['telefono'],
                    'email': empresa['email'],
                    'direccion': empresa['direccion'],
                    'id_estado_empresa': empresa['id_estado_empresa'],
                    'nombre_estado': empresa['nombre_estado'],
                    'fecha_creacion': empresa['fecha_creacion'].isoformat() if empresa['fecha_creacion'] else None,
                    'fecha_actualizacion': empresa['fecha_actualizacion'].isoformat() if empresa['fecha_actualizacion'] else None
                })
            
            return jsonify(empresas_list)
        except Exception as e:
            logger.error(f"Error al obtener empresas: {str(e)}")
            return jsonify({'error': 'Error al obtener empresas'}), 500

    @empresas_bp.route('/api/empresas/<int:id_empresa>', methods=['GET'])
    def obtener_empresa(id_empresa):
        """Obtener una empresa específica"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('obtenerEmpresaPorId', [id_empresa])
            empresa = cur.fetchone()
            cur.close()
            
            if empresa:
                empresa_data = {
                    'id_empresa': empresa['id_empresa'],
                    'nombre': empresa['nombre'],
                    'telefono': empresa['telefono'],
                    'email': empresa['email'],
                    'direccion': empresa['direccion'],
                    'id_estado_empresa': empresa['id_estado_empresa'],
                    'nombre_estado': empresa['nombre_estado'],
                    'fecha_creacion': empresa['fecha_creacion'].isoformat() if empresa['fecha_creacion'] else None,
                    'fecha_actualizacion': empresa['fecha_actualizacion'].isoformat() if empresa['fecha_actualizacion'] else None
                }
                return jsonify(empresa_data)
            else:
                return jsonify({'error': 'Empresa no encontrada'}), 404
        except Exception as e:
            logger.error(f"Error al obtener empresa: {str(e)}")
            return jsonify({'error': 'Error al obtener empresa'}), 500

    @empresas_bp.route('/api/empresas', methods=['POST'])
    def crear_empresa():
        """Crear una nueva empresa"""
        cur = None
        try:
            data = request.get_json()
            nombre = data.get('nombre')
            telefono = data.get('telefono')
            email = data.get('email')
            direccion = data.get('direccion')
            id_estado_empresa = data.get('id_estado_empresa', 1)

            if not nombre:
                return jsonify({'error': 'El nombre es obligatorio'}), 400

            cur = mysql.connection.cursor()
            cur.callproc('crearEmpresa', [
                nombre, 
                telefono, 
                email, 
                direccion, 
                id_estado_empresa
            ])
            
            # Obtener el resultado del procedimiento
            result = cur.fetchone()
            
            # IMPORTANTE: Consumir todos los resultados antes de commit
            while cur.nextset():
                pass
                
            mysql.connection.commit()
            
            if result and result.get('success') == 1:
                return jsonify({
                    'message': 'Empresa creada exitosamente',
                    'id_empresa': result['id_empresa']
                }), 201
            else:
                return jsonify({'error': 'Error al crear empresa'}), 500

        except MySQLdb.IntegrityError as e:
            if cur:
                try:
                    while cur.nextset():
                        pass
                except:
                    pass
                mysql.connection.rollback()
            if 'email' in str(e):
                return jsonify({'error': 'El email ya está registrado'}), 400
            return jsonify({'error': 'Error de integridad de datos'}), 400
        except Exception as e:
            if cur:
                try:
                    while cur.nextset():
                        pass
                except:
                    pass
                mysql.connection.rollback()
            logger.error(f"Error al crear empresa: {str(e)}")
            return jsonify({'error': f'Error al crear empresa: {str(e)}'}), 500
        finally:
            if cur:
                cur.close()

    @empresas_bp.route('/api/empresas/<int:id_empresa>', methods=['PUT'])
    def actualizar_empresa(id_empresa):
        """Actualizar una empresa existente"""
        cur = None
        try:
            data = request.get_json()
            nombre = data.get('nombre')
            telefono = data.get('telefono')
            email = data.get('email')
            direccion = data.get('direccion')
            id_estado_empresa = data.get('id_estado_empresa')

            if not nombre:
                return jsonify({'error': 'El nombre es obligatorio'}), 400

            cur = mysql.connection.cursor()
            cur.callproc('actualizarEmpresa', [
                id_empresa,
                nombre, 
                telefono, 
                email, 
                direccion, 
                id_estado_empresa
            ])
            
            # Obtener el resultado del procedimiento
            result = cur.fetchone()
            
            # IMPORTANTE: Consumir todos los resultados antes de commit
            while cur.nextset():
                pass
                
            mysql.connection.commit()

            if result and result.get('success') == 1:
                return jsonify({'message': 'Empresa actualizada exitosamente'})
            else:
                return jsonify({'error': 'Empresa no encontrada'}), 404

        except MySQLdb.IntegrityError as e:
            if cur:
                try:
                    while cur.nextset():
                        pass
                except:
                    pass
                mysql.connection.rollback()
            if 'email' in str(e):
                return jsonify({'error': 'El email ya está registrado'}), 400
            return jsonify({'error': 'Error de integridad de datos'}), 400
        except Exception as e:
            if cur:
                try:
                    while cur.nextset():
                        pass
                except:
                    pass
                mysql.connection.rollback()
            logger.error(f"Error al actualizar empresa: {str(e)}")
            return jsonify({'error': f'Error al actualizar empresa: {str(e)}'}), 500
        finally:
            if cur:
                cur.close()

    @empresas_bp.route('/api/empresas/<int:id_empresa>', methods=['DELETE'])
    def eliminar_empresa(id_empresa):
        """Eliminar una empresa"""
        cur = None
        try:
            cur = mysql.connection.cursor()
            cur.callproc('eliminarEmpresa', [id_empresa])
            
            # Obtener el resultado del procedimiento
            result = cur.fetchone()
            
            # IMPORTANTE: Consumir todos los resultados antes de commit
            while cur.nextset():
                pass
                
            mysql.connection.commit()

            if result and result.get('success') == 1:
                return jsonify({'message': 'Empresa eliminada exitosamente'})
            else:
                return jsonify({'error': 'Empresa no encontrada'}), 404

        except Exception as e:
            if cur:
                try:
                    while cur.nextset():
                        pass
                except:
                    pass
                mysql.connection.rollback()
            logger.error(f"Error al eliminar empresa: {str(e)}")
            return jsonify({'error': f'Error al eliminar empresa: {str(e)}'}), 500
        finally:
            if cur:
                cur.close()

    @empresas_bp.route('/api/empresas/estadisticas', methods=['GET'])
    def obtener_estadisticas_empresas():
        """Obtener estadísticas de empresas"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('obtenerEstadisticasEmpresas')
            stats = cur.fetchone()
            cur.close()
            
            return jsonify({
                'total_empresas': stats['total_empresas'],
                'empresas_activas': stats['empresas_activas'],
                'empresas_inactivas': stats['empresas_inactivas'],
                'empresas_suspendidas': stats['empresas_suspendidas']
            })
        except Exception as e:
            logger.error(f"Error al obtener estadísticas: {str(e)}")
            return jsonify({'error': 'Error al obtener estadísticas'}), 500

    @empresas_bp.route('/api/empresas/<int:id_empresa>/pedidos', methods=['GET'])
    def obtener_pedidos_empresa(id_empresa):
        """Obtener pedidos de una empresa específica"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('obtenerPedidosPorEmpresa', [id_empresa])
            pedidos = cur.fetchall()
            cur.close()
            
            pedidos_list = []
            for pedido in pedidos:
                pedidos_list.append({
                    'id_pedido': pedido['id_pedido'],
                    'fecha_pedido': pedido['fecha_pedido'].isoformat() if pedido['fecha_pedido'] else None,
                    'total_pedido': float(pedido['total_pedido']) if pedido['total_pedido'] else 0,
                    'nombre_estado': pedido['nombre_estado'],
                    'fecha_estimada_entrega': pedido['fecha_estimada_entrega'].isoformat() if pedido['fecha_estimada_entrega'] else None,
                    'nombre_cliente': pedido['nombre_cliente']
                })
            
            return jsonify(pedidos_list)
        except Exception as e:
            logger.error(f"Error al obtener pedidos de empresa: {str(e)}")
            return jsonify({'error': 'Error al obtener pedidos'}), 500

    return empresas_bp