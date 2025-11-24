from flask import Blueprint, jsonify, request, render_template, session  
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required

clientes_bp = Blueprint('clientes', __name__)

def init_clientes_routes(app, mysql):
    # Ruta para la página principal de clientes
    clientes_bp = Blueprint('clientes', __name__)
    @login_required
    def clientes_page():
        return render_template('clientes.html')

    # API Routes - Versión corregida para manejar múltiples resultados
    @clientes_bp.route('/api/clientes', methods=['GET'])
    @login_required
    @role_required([1, 2])
    def obtener_clientes():
        """Obtener clientes con paginación y filtros"""
        cur1 = None
        cur2 = None
        try:
            estado = request.args.get('estado', '')
            busqueda = request.args.get('busqueda', '')
            pagina = int(request.args.get('pagina', 1))
            limite = int(request.args.get('limite', 10))
            
            offset = (pagina - 1) * limite
            
            cur1 = mysql.connection.cursor()
            cur1.callproc('clientesListar', [estado, busqueda, offset, limite])
            
            clientes = cur1.fetchall()
            
            # Avanzar al siguiente resultado
            if cur1.nextset():
                paginacion = cur1.fetchone()
            else:
                paginacion = {}
            
            cur1.close()
            cur1 = None
            
            # Estadísticas con cursor separado
            cur2 = mysql.connection.cursor()
            cur2.callproc('clientesResumenEstados')
            estadisticas = cur2.fetchone()
            cur2.close()
            cur2 = None
            
            return jsonify({
                'clientes': clientes,
                'paginacion': paginacion,
                'estadisticas': estadisticas
            })
            
        except Exception as e:
            print(f"Error en obtener_clientes: {str(e)}")
            return jsonify({'error': 'Error al obtener la lista de clientes'}), 500
            
        finally:
            if cur1:
                try:
                    cur1.close()
                except:
                    pass
            if cur2:
                try:
                    cur2.close()
                except:
                    pass

    @clientes_bp.route('/api/zonas', methods=['GET'])
    @login_required
    def obtener_zonas():
        """Obtener catálogo de zonas activas"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('zonasActivasListar')
            zonas = cur.fetchall()
            cur.close()
            return jsonify(zonas)
        except Exception as e:
            print(f"Error en obtener_zonas: {str(e)}")
            return jsonify({'error': str(e)}), 500

    @clientes_bp.route('/api/clientes', methods=['POST'])
    @login_required
    @role_required([1, 2])
    def crear_cliente():
        """Crear nuevo cliente"""
        cur = None
        try:
            data = request.get_json()
            
            # Obtener el usuario del sistema
            usuario_sistema = session.get('user_name', 'admin')
            user_id = session.get('user_id')
            
            # Si no tenemos el nombre pero sí tenemos el ID, usar el procedimiento
            if (not usuario_sistema or usuario_sistema == 'admin') and user_id:
                cur_user = mysql.connection.cursor()
                cur_user.callproc('obtenerNombreUsuario', [user_id])
                result_user = cur_user.fetchone()
                if result_user and 'nombre_usuario' in result_user:
                    usuario_sistema = result_user['nombre_usuario']
                cur_user.close()
            
            print(f"Usuario que crea cliente: {usuario_sistema}")
            
            cur = mysql.connection.cursor()
            
            # 8 PARÁMETROS: todos los datos + usuario_sistema
            cur.callproc('clienteCrearActualizar', [
                None,  # p_id_cliente (NULL para crear nuevo)
                data['nombre'],
                data.get('telefono', ''),
                data.get('email', ''),
                data.get('direccion', ''),
                data.get('id_zona', 1),
                data.get('id_estado_cliente', 1),
                usuario_sistema  # PARÁMETRO NUEVO
            ])
            result = cur.fetchone()
            
            # Consumir todos los resultados
            while cur.nextset():
                pass
            
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': 'Cliente creado', 'id': result['id_cliente']})
        except Exception as e:
            print(f"Error en crear_cliente: {str(e)}")
            mysql.connection.rollback()
            return jsonify({'error': str(e)}), 500

    @clientes_bp.route('/api/clientes/<int:id>', methods=['GET'])
    @login_required
    @role_required([1, 2])
    def obtener_cliente(id):
        """Obtener cliente por ID"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('clienteObtenerPorId', [id])
            cliente = cur.fetchone()
            cur.close()  # CORRECCIÓN: Cerrar cursor después de usar
            
            if not cliente:
                return jsonify({'error': 'Cliente no encontrado'}), 404
                
            return jsonify(cliente)
        except Exception as e:
            print(f"Error en obtener_cliente: {str(e)}")
            return jsonify({'error': 'Error al obtener el cliente'}), 500

    @clientes_bp.route('/api/clientes/<int:id>', methods=['PUT'])
    @login_required
    @role_required([1, 2])
    def actualizar_cliente(id):
        """Actualizar cliente"""
        cur = None
        try:
            data = request.get_json()
            
            # Obtener el usuario del sistema
            usuario_sistema = session.get('user_name', 'admin')
            user_id = session.get('user_id')
            
            # Si no tenemos el nombre pero sí tenemos el ID, usar el procedimiento
            if (not usuario_sistema or usuario_sistema == 'admin') and user_id:
                cur_user = mysql.connection.cursor()
                cur_user.callproc('obtenerNombreUsuario', [user_id])
                result_user = cur_user.fetchone()
                if result_user and 'nombre_usuario' in result_user:
                    usuario_sistema = result_user['nombre_usuario']
                cur_user.close()
            
            print(f"Usuario que actualiza cliente: {usuario_sistema}")
            
            cur = mysql.connection.cursor()
            
            # 8 PARÁMETROS: todos los datos + usuario_sistema
            cur.callproc('clienteCrearActualizar', [
                id,  # p_id_cliente (valor para actualizar)
                data['nombre'],
                data.get('telefono', ''),
                data.get('email', ''),
                data.get('direccion', ''),
                data.get('id_zona', 1),
                data.get('id_estado_cliente', 1),
                usuario_sistema  # PARÁMETRO NUEVO
            ])
            result = cur.fetchone()
            
            # Consumir todos los resultados
            while cur.nextset():
                pass
            
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': 'Cliente actualizado', 'id': result['id_cliente']})
        except Exception as e:
            print(f"Error en actualizar_cliente: {str(e)}")
            mysql.connection.rollback()
            return jsonify({'error': str(e)}), 500

    @clientes_bp.route('/api/clientes/<int:id>', methods=['DELETE'])
    @login_required
    @role_required([1])
    def eliminar_cliente(id):
        """Eliminar cliente físicamente y registrar en auditoría"""
        cur = None
        try:
            # Obtener el usuario del sistema
            usuario_sistema = session.get('user_name', 'admin')
            user_id = session.get('user_id')
            
            # Si no tenemos el nombre pero sí tenemos el ID, usar el procedimiento
            if (not usuario_sistema or usuario_sistema == 'admin') and user_id:
                cur_user = mysql.connection.cursor()
                cur_user.callproc('obtenerNombreUsuario', [user_id])
                result_user = cur_user.fetchone()
                if result_user and 'nombre_usuario' in result_user:
                    usuario_sistema = result_user['nombre_usuario']
                cur_user.close()
            
            print(f"Usuario que elimina: {usuario_sistema}")
            
            cur = mysql.connection.cursor()
            
            # 2 PARÁMETROS: id_cliente y usuario_sistema
            cur.callproc('clienteEliminar', [id, usuario_sistema])
            result = cur.fetchone()
            
            # Consumir todos los resultados
            while cur.nextset():
                pass
            
            mysql.connection.commit()
            
            if result and 'mensaje' in result:
                return jsonify({'message': result['mensaje']})
            else:
                return jsonify({'error': 'No se pudo eliminar el cliente'}), 500
                
        except Exception as e:
            print(f"Error en eliminar_cliente: {str(e)}")
            return jsonify({'error': str(e)}), 500
            
        finally:
            if cur:
                try:
                    cur.close()
                except:
                    pass
                
    @clientes_bp.route('/api/clientes/<int:id>/direcciones', methods=['GET'])
    @login_required
    def obtener_direcciones_cliente(id):
        """Obtener direcciones activas de un cliente"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('clienteDireccionesListar', [id])
            direcciones = cur.fetchall()
            cur.close()
            return jsonify(direcciones)
        except Exception as e:
            print(f"Error en obtener_direcciones_cliente: {str(e)}")
            return jsonify({'error': str(e)}), 500

    @clientes_bp.route('/api/productos', methods=['GET'])
    @login_required
    def obtener_productos():
        """Obtener catálogo de productos"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('productosActivosListar')
            productos = cur.fetchall()
            cur.close()
            return jsonify(productos)
        except Exception as e:
            print(f"Error en obtener_productos: {str(e)}")
            return jsonify({'error': str(e)}), 500

    return clientes_bp