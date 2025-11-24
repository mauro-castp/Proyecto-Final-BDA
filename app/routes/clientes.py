from flask import Blueprint, jsonify, request, render_template
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required

clientes_bp = Blueprint('clientes', __name__)

def init_clientes_routes(app, mysql):
    # Ruta para la página principal de clientes
    @clientes_bp.route('/clientes')
    @login_required
    def clientes_page():
        return render_template('clientes.html')

    # API Routes - Versión corregida para manejar múltiples resultados
    @clientes_bp.route('/api/clientes', methods=['GET'])
    @login_required
    @role_required([1, 2])
    def obtener_clientes():
        """Obtener clientes con paginación y filtros"""
        try:
            # Obtener parámetros de consulta
            estado = request.args.get('estado', '')
            busqueda = request.args.get('busqueda', '')
            pagina = int(request.args.get('pagina', 1))
            limite = int(request.args.get('limite', 10))
            
            offset = (pagina - 1) * limite
            
            cur = mysql.connection.cursor()
            
            # Llamar al procedimiento que devuelve múltiples resultados
            cur.callproc('clientesListar', [estado, busqueda, offset, limite])
            
            # Primer resultado: lista de clientes
            clientes = cur.fetchall()
            
            # Avanzar al siguiente resultado
            cur.nextset()
            
            # Segundo resultado: información de paginación
            paginacion = cur.fetchone()
            
            # Cerrar cursor antes de crear uno nuevo para estadísticas
            cur.close()
            
            # Obtener estadísticas con cursor separado
            cur2 = mysql.connection.cursor()
            cur2.callproc('clientesResumenEstados')
            estadisticas = cur2.fetchone()
            cur2.close()
            
            return jsonify({
                'clientes': clientes,
                'paginacion': paginacion,
                'estadisticas': estadisticas
            })
            
        except Exception as e:
            print(f"Error en obtener_clientes: {str(e)}")
            return jsonify({'error': str(e)}), 500

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
        try:
            data = request.get_json()
            cur = mysql.connection.cursor()
            
            cur.callproc('clienteCrearActualizar', [
                None,  # p_id_cliente (NULL para crear nuevo)
                data['nombre'],
                data.get('telefono', ''),
                data.get('email', ''),
                data.get('direccion', ''),
                data.get('id_zona', 1)
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': 'Cliente creado', 'id': result['id_cliente']})
        except Exception as e:
            print(f"Error en crear_cliente: {str(e)}")
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
            cur.close()
            
            if not cliente:
                return jsonify({'error': 'Cliente no encontrado'}), 404
                
            return jsonify(cliente)
        except Exception as e:
            print(f"Error en obtener_cliente: {str(e)}")
            return jsonify({'error': str(e)}), 500

    @clientes_bp.route('/api/clientes/<int:id>', methods=['PUT'])
    @login_required
    @role_required([1, 2])
    def actualizar_cliente(id):
        """Actualizar cliente"""
        try:
            data = request.get_json()
            cur = mysql.connection.cursor()
            
            cur.callproc('clienteCrearActualizar', [
                id,  # p_id_cliente (valor para actualizar)
                data['nombre'],
                data.get('telefono', ''),
                data.get('email', ''),
                data.get('direccion', ''),
                data.get('id_zona', 1)
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': 'Cliente actualizado', 'id': result['id_cliente']})
        except Exception as e:
            print(f"Error en actualizar_cliente: {str(e)}")
            return jsonify({'error': str(e)}), 500

    @clientes_bp.route('/api/clientes/<int:id>', methods=['DELETE'])
    @login_required
    @role_required([1])
    def eliminar_cliente(id):
        """Eliminar cliente (soft delete)"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('clienteEliminar', [id])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': result['mensaje']})
        except Exception as e:
            print(f"Error en eliminar_cliente: {str(e)}")
            return jsonify({'error': str(e)}), 500

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