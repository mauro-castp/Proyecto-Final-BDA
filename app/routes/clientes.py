# routes/clientes.py
from flask import Blueprint, jsonify, request
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required

clientes_bp = Blueprint('clientes', __name__)

def init_clientes_routes(app, mysql):
    @clientes_bp.route('/api/clientes', methods=['GET'])
    @login_required
    @role_required([1, 2])
    def obtener_clientes():
        """Obtener todos los clientes - vía procedimiento"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('clientesActivosListar')
            clientes = cur.fetchall()
            cur.close()
            return jsonify(clientes)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @clientes_bp.route('/api/clientes', methods=['POST'])
    @login_required
    @role_required([1, 2])
    def crear_cliente():
        """Crear nuevo cliente - PROCEDIMIENTO"""
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
            return jsonify({'error': str(e)}), 500

    @clientes_bp.route('/api/clientes/<int:id>', methods=['GET'])
    @login_required
    @role_required([1, 2])
    def obtener_cliente(id):
        """Obtener cliente por ID - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('clienteObtenerPorId', [id])
            cliente = cur.fetchone()
            cur.close()
            
            if not cliente:
                return jsonify({'error': 'Cliente no encontrado'}), 404
                
            return jsonify(cliente)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @clientes_bp.route('/api/clientes/<int:id>', methods=['PUT'])
    @login_required
    @role_required([1, 2])
    def actualizar_cliente(id):
        """Actualizar cliente - PROCEDIMIENTO"""
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
            return jsonify({'error': str(e)}), 500

    @clientes_bp.route('/api/clientes/<int:id>', methods=['DELETE'])
    @login_required
    @role_required([1])
    def eliminar_cliente(id):
        """Eliminar cliente (soft delete) - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('clienteEliminar', [id])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': result['mensaje']})
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    # Catálogos auxiliares
    @clientes_bp.route('/api/productos', methods=['GET'])
    @login_required
    def obtener_productos():
        """Obtener catálogo de productos - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('productosActivosListar')
            productos = cur.fetchall()
            cur.close()
            return jsonify(productos)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @clientes_bp.route('/api/clientes/<int:id>/direcciones', methods=['GET'])
    @login_required
    def obtener_direcciones_cliente(id):
        """Obtener direcciones activas de un cliente - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('clienteDireccionesListar', [id])
            direcciones = cur.fetchall()
            cur.close()
            return jsonify(direcciones)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return clientes_bp