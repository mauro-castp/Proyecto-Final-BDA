# routes/entregas.py
from flask import Blueprint, jsonify, request, session
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required

entregas_bp = Blueprint('entregas', __name__)

def init_entregas_routes(app, mysql):
    
    # ==================== CRUD COMPLETO ====================
    
    # CREATE - Asignar entrega
    @entregas_bp.route('/api/entregas', methods=['POST'])
    @login_required
    @role_required([1, 2])  # Admin y Planificador
    def crear_entrega():
        """Crear nueva entrega - CREATE"""
        try:
            data = request.get_json()
            required_fields = ['id_pedido', 'id_vehiculo', 'id_repartidor']
            
            # Validar campos requeridos
            for field in required_fields:
                if field not in data or data[field] is None:
                    return jsonify({'error': f'Campo requerido: {field}'}), 400
            
            cur = mysql.connection.cursor()
            
            # Llamar al procedimiento existente
            cur.callproc('entregaAsignar', [
                data['id_pedido'],
                data.get('id_ruta'),
                data['id_vehiculo'],
                data['id_repartidor']
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            if result['status'] == 'capacidad_insuficiente':
                return jsonify({'error': 'Capacidad del vehículo insuficiente'}), 400
            else:
                return jsonify({
                    'message': 'Entrega asignada correctamente', 
                    'id_entrega': result['status']
                }), 201
                
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    # READ - Obtener todas las entregas con filtros (VERSIÓN SIMPLIFICADA)
    @entregas_bp.route('/api/entregas', methods=['GET'])
    @login_required
    def obtener_entregas():
        """Obtener entregas con filtros y paginación - READ"""
        try:
            # Obtener parámetros de filtro
            estado = request.args.get('estado', '')
            repartidor = request.args.get('repartidor', '')
            fecha = request.args.get('fecha', '')
            pagina = request.args.get('pagina', 1, type=int)
            limite = request.args.get('limite', 10, type=int)
            
            # Calcular offset
            offset = (pagina - 1) * limite
            
            cur = mysql.connection.cursor()
            
            # VERSIÓN SIMPLIFICADA - Usar el procedimiento existente entregasObtenerTodas
            cur.callproc('entregasObtenerTodas')
            todas_las_entregas = cur.fetchall()
            cur.close()
            
            # Aplicar filtros manualmente
            entregas_filtradas = todas_las_entregas
            
            if estado:
                entregas_filtradas = [e for e in entregas_filtradas if str(e.get('id_estado_entrega')) == estado]
            
            if repartidor:
                entregas_filtradas = [e for e in entregas_filtradas if str(e.get('id_repartidor')) == repartidor]
            
            if fecha:
                entregas_filtradas = [e for e in entregas_filtradas 
                                    if e.get('fecha_estimada_entrega') 
                                    and str(e.get('fecha_estimada_entrega')).startswith(fecha)]
            
            # Aplicar paginación
            total_registros = len(entregas_filtradas)
            total_paginas = max(1, (total_registros + limite - 1) // limite)
            entregas_paginadas = entregas_filtradas[offset:offset + limite]
            
            return jsonify({
                'entregas': entregas_paginadas,
                'paginacion': {
                    'total_registros': total_registros,
                    'total_paginas': total_paginas,
                    'limite': limite,
                    'offset_actual': offset
                }
            })
            
        except Exception as e:
            print(f"Error en obtener_entregas: {str(e)}")  # Para debugging
            return jsonify({'error': str(e)}), 500

    # READ - Obtener entrega específica
    @entregas_bp.route('/api/entregas/<int:id>', methods=['GET'])
    @login_required
    def obtener_entrega(id):
        """Obtener entrega por ID - READ"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('entregaObtenerPorId', [id])
            entrega = cur.fetchone()
            cur.close()
            
            if not entrega:
                return jsonify({'error': 'Entrega no encontrada'}), 404
                
            return jsonify(entrega)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    # UPDATE - Actualizar entrega (confirmar)
    @entregas_bp.route('/api/entregas/<int:id>/confirmar', methods=['POST'])
    @login_required
    @role_required([1, 2, 3])
    def actualizar_entrega_confirmar(id):
        """Confirmar entrega - UPDATE"""
        try:
            data = request.get_json()
            
            # Validar campos requeridos
            if 'hora_real' not in data:
                return jsonify({'error': 'Campo requerido: hora_real'}), 400
            
            cur = mysql.connection.cursor()
            
            cur.callproc('entregaConfirmar', [
                id,
                data['hora_real'],
                data.get('evidencia_url', '')
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            if result['status'] == 'estado_invalido':
                return jsonify({'error': 'Estado de entrega inválido'}), 400
            else:
                return jsonify({'message': 'Entrega confirmada correctamente'})
                
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    # UPDATE - Reintentar entrega
    @entregas_bp.route('/api/entregas/<int:id>/reintento', methods=['POST'])
    @login_required
    @role_required([1, 2, 3])
    def actualizar_entrega_reintento(id):
        """Registrar reintento de entrega - UPDATE"""
        try:
            data = request.get_json()
            
            # Validar campos requeridos
            if 'motivo_fallo' not in data:
                return jsonify({'error': 'Campo requerido: motivo_fallo'}), 400
            
            cur = mysql.connection.cursor()
            
            cur.callproc('entregaReintento', [
                id,
                data['motivo_fallo']
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            if result['status'] == 'limite_reintentos':
                return jsonify({'error': 'Límite de reintentos alcanzado'}), 400
            else:
                return jsonify({'message': 'Reintento registrado correctamente'})
                
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    # DELETE - Eliminar entrega
    @entregas_bp.route('/api/entregas/<int:id>', methods=['DELETE'])
    @login_required
    @role_required([1, 2])  # Solo admin y planificador
    def eliminar_entrega(id):
        """Eliminar entrega - DELETE"""
        try:
            cur = mysql.connection.cursor()
            
            # Obtener nombre de usuario para el procedimiento
            cur.callproc('obtenerNombreUsuario', [session['user_id']])
            usuario_result = cur.fetchone()
            usuario_sistema = usuario_result['nombre_usuario'] if usuario_result else 'sistema'
            
            # Llamar al procedimiento de eliminación
            cur.callproc('entregaEliminar', [id, usuario_sistema])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            if result['success'] == 1:
                return jsonify({'message': result['mensaje']})
            else:
                return jsonify({'error': result['mensaje']}), 400
                
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    # ==================== ENDPOINTS ADICIONALES ====================
    
    @entregas_bp.route('/api/entregas/<int:id>/estado', methods=['PUT'])
    @login_required
    @role_required([1, 2])
    def cambiar_estado_entrega(id):
        """Cambiar estado de una entrega"""
        try:
            data = request.get_json()
            nuevo_estado = data.get('id_estado_entrega')
            
            if not nuevo_estado:
                return jsonify({'error': 'Campo requerido: id_estado_entrega'}), 400
            
            cur = mysql.connection.cursor()
            
            # Obtener nombre de usuario para el procedimiento
            cur.callproc('obtenerNombreUsuario', [session['user_id']])
            usuario_result = cur.fetchone()
            usuario_sistema = usuario_result['nombre_usuario'] if usuario_result else 'sistema'
            
            # Llamar al procedimiento para cambiar estado
            cur.callproc('entregaCambiarEstado', [id, nuevo_estado, usuario_sistema])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': result['mensaje']})
            
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @entregas_bp.route('/api/entregas/<int:id>/repartidor', methods=['PUT'])
    @login_required
    @role_required([1, 2])
    def reasignar_repartidor(id):
        """Reasignar repartidor a una entrega"""
        try:
            data = request.get_json()
            nuevo_repartidor = data.get('id_repartidor')
            
            if not nuevo_repartidor:
                return jsonify({'error': 'Campo requerido: id_repartidor'}), 400
            
            cur = mysql.connection.cursor()
            
            # Obtener nombre de usuario para el procedimiento
            cur.callproc('obtenerNombreUsuario', [session['user_id']])
            usuario_result = cur.fetchone()
            usuario_sistema = usuario_result['nombre_usuario'] if usuario_result else 'sistema'
            
            # Llamar al procedimiento para reasignar repartidor
            cur.callproc('entregaReasignarRepartidor', [id, nuevo_repartidor, usuario_sistema])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': result['mensaje']})
            
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    # ==================== DATOS PARA FORMULARIOS ====================
    
    @entregas_bp.route('/api/entregas/repartidores', methods=['GET'])
    @login_required
    def obtener_repartidores():
        """Obtener lista de repartidores activos"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('repartidoresActivosListar')
            repartidores = cur.fetchall()
            cur.close()
            
            return jsonify(repartidores)
            
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @entregas_bp.route('/api/entregas/vehiculos', methods=['GET'])
    @login_required
    def obtener_vehiculos():
        """Obtener lista de vehículos disponibles"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('vehiculosDisponiblesListar')
            vehiculos = cur.fetchall()
            cur.close()
            
            return jsonify(vehiculos)
            
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @entregas_bp.route('/api/entregas/pedidos-pendientes', methods=['GET'])
    @login_required
    @role_required([1, 2])
    def obtener_pedidos_pendientes():
        """Obtener pedidos pendientes de asignación"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('pedidosListar', [session['user_id'], session['user_role'], 'pendiente', None, None, 0, 100])
            pedidos = cur.fetchall()
            cur.close()
            
            # Filtrar solo pedidos sin entrega asignada
            pedidos_pendientes = []
            for pedido in pedidos:
                # Verificar si el pedido ya tiene entrega
                cur = mysql.connection.cursor()
                cur.execute("SELECT COUNT(*) as tiene_entrega FROM entregas WHERE id_pedido = %s", (pedido['id_pedido'],))
                resultado = cur.fetchone()
                cur.close()
                
                if resultado['tiene_entrega'] == 0:
                    pedidos_pendientes.append(pedido)
            
            return jsonify(pedidos_pendientes)
            
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    # ==================== ESTADÍSTICAS ====================
    
    @entregas_bp.route('/api/entregas/estadisticas', methods=['GET'])
    @login_required
    def obtener_estadisticas_entregas():
        """Obtener estadísticas de entregas"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('entregasEstadisticas')
            estadisticas = cur.fetchone()
            cur.close()
            
            return jsonify(estadisticas)
            
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    # ==================== ENDPOINTS PARA REPARTIDORES ====================
    
    @entregas_bp.route('/api/mis-entregas', methods=['GET'])
    @login_required
    @role_required([3])  # Solo repartidores
    def obtener_mis_entregas():
        """Obtener entregas del repartidor actual"""
        try:
            # Obtener parámetros de filtro
            estado = request.args.get('estado', '')
            fecha = request.args.get('fecha', '')
            pagina = request.args.get('pagina', 1, type=int)
            limite = request.args.get('limite', 10, type=int)
            
            # Calcular offset
            offset = (pagina - 1) * limite
            
            cur = mysql.connection.cursor()
            
            # Llamar al procedimiento de listar entregas para repartidor
            cur.callproc('entregasListar', [
                session['user_id'],
                session['user_role'],
                estado,
                session['user_id'],  # Filtro por repartidor actual
                fecha,
                offset,
                limite
            ])
            
            # Obtener resultados
            entregas = cur.fetchall()
            
            # Obtener información de paginación
            if cur.nextset():
                paginacion = cur.fetchone()
            
            cur.close()
            
            return jsonify({
                'entregas': entregas,
                'paginacion': paginacion
            })
            
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return entregas_bp