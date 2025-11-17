# app.py - VERSIÓN COMPLETA
from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
from flask_mysqldb import MySQL
from functools import wraps
import os
from datetime import datetime
from flasgger import Swagger

app = Flask(__name__)

# Configuración
app.secret_key = 'clave-secreta-lum-2024-desarrollo'
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'lum_user'
app.config['MYSQL_PASSWORD'] = '666'
app.config['MYSQL_DB'] = 'LUM'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

# Configuración Swagger MEJORADA
# Configuración Swagger CORREGIDA
app.config['SWAGGER'] = {
    'title': 'LUM API - Logística Última Milla',
    'description': 'API completa para el sistema de logística de última milla',
    'version': '1.0.0',
    'uiversion': 3,
    'specs_route': '/api/docs/',
    'openapi': '3.0.0' 
}

swagger_template = {
    "openapi": "3.0.0", 
    "info": {
        "title": "LUM API - Logística Última Milla",
        "description": "Documentación completa de la API del sistema de logística",
        "version": "1.0.0",
    },
    "host": "localhost:5000",
    "basePath": "/",
    "schemes": ["http", "https"],
    "components": {
        "securitySchemes": {
            "Bearer": {
                "type": "http",
                "scheme": "bearer",
                "bearerFormat": "JWT"
            }
        }
    }
}

swagger = Swagger(app, template=swagger_template)

mysql = MySQL(app)

# ==================== DECORADORES ====================
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            if request.path.startswith('/api/'):
                return jsonify({'error': 'No autenticado'}), 401
            flash('Debe iniciar sesión', 'error')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

def role_required(roles):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user_id' not in session:
                if request.path.startswith('/api/'):
                    return jsonify({'error': 'No autenticado'}), 401
                flash('Debe iniciar sesión', 'error')
                return redirect(url_for('login'))
                
            if session['user_role'] not in roles:
                if request.path.startswith('/api/'):
                    return jsonify({'error': 'Permisos insuficientes'}), 403
                flash('No tiene permisos para esta acción', 'error')
                return redirect(url_for('index'))
            return f(*args, **kwargs)
        return decorated_function
    return decorator

# ==================== RUTAS PRINCIPALES ====================
@app.route('/')
def index():
    """Página principal del sistema"""
    if 'user_id' not in session:
        return redirect(url_for('login'))
    return render_template('index.html')

# @app.route('/login', methods=['GET', 'POST'])
# def login():
#     """Página de login"""
#     if 'user_id' in session:
#         return redirect(url_for('index'))
    
#     if request.method == 'POST':
#         try:
#             email = request.form['email']
#             password = request.form['password']
            
#             cur = mysql.connection.cursor()
#             cur.callproc('usuarioLogin', [email, password])
#             result = cur.fetchone()
#             cur.close()
            
#             if result:
#                 session['user_id'] = result['id_usuario']
#                 session['user_name'] = result['nombre']
#                 session['user_role'] = result['nombre_rol']
#                 session['user_email'] = result['email']
                
#                 flash(f'Bienvenido/a {session["user_name"]}', 'success')
#                 return redirect(url_for('index'))
#             else:
#                 flash('Credenciales incorrectas', 'error')
                
#         except Exception as e:
#             flash(f'Error en el login: {str(e)}', 'error')
    
#     return render_template('login.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    """Página de login - VERSIÓN TEMPORAL (SQL DIRECTO)"""
    if 'user_id' in session:
        return redirect(url_for('index'))
    
    if request.method == 'POST':
        try:
            email = request.form['email']
            password = request.form['password']
            
            cur = mysql.connection.cursor()
            
            # SQL CORREGIDO según tu estructura de base de datos
            query = """
            SELECT u.id_usuario, u.nombre, r.nombre_rol, u.email 
            FROM usuarios u 
            INNER JOIN roles r ON u.id_rol = r.id_rol 
            WHERE u.email = %s AND u.password_hash = %s
            """
            cur.execute(query, (email, password))
            result = cur.fetchone()
            cur.close()
            
            if result:
                session['user_id'] = result['id_usuario']
                session['user_name'] = result['nombre']
                session['user_role'] = result['nombre_rol']
                session['user_email'] = result['email']
                
                flash(f'Bienvenido/a {session["user_name"]}', 'success')
                return redirect(url_for('index'))
            else:
                flash('Credenciales incorrectas', 'error')
                
        except Exception as e:
            flash(f'Error en el login: {str(e)}', 'error')
    
    return render_template('login.html')

@app.route('/logout')
def logout():
    """Cerrar sesión"""
    session.clear()
    flash('Sesión cerrada correctamente', 'info')
    return redirect(url_for('login'))

# ==================== HEALTH CHECK ====================
@app.route('/api/health')
def health_check():
    """
    Health Check del sistema
    ---
    tags:
      - Sistema
    responses:
      200:
        description: Estado del sistema
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT 1 as status, NOW() as timestamp, VERSION() as version")
        result = cur.fetchone()
        cur.close()
        
        return jsonify({
            'status': 'healthy',
            'database': 'connected',
            'timestamp': datetime.now().isoformat(),
            'version': result['version']
        })
    except Exception as e:
        return jsonify({
            'status': 'unhealthy',
            'database': 'disconnected',
            'error': str(e),
            'timestamp': datetime.now().isoformat()
        }), 500

# ==================== AUTENTICACIÓN API ====================
@app.route('/api/auth/login', methods=['POST'])
def api_login():
    """
    Autenticación de usuario (API)
    ---
    tags:
      - Autenticación
    parameters:
      - name: body
        in: body
        required: true
        schema:
          type: object
          required:
            - email
            - password
          properties:
            email:
              type: string
              example: "admin@demo.com"
            password:
              type: string
              example: "admin123"
    responses:
      200:
        description: Login exitoso
      401:
        description: Credenciales incorrectas
    """
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')
        
        cur = mysql.connection.cursor()
        cur.callproc('usuarioLogin', [email, password])
        result = cur.fetchone()
        cur.close()
        
        if result:
            session['user_id'] = result['id_usuario']
            session['user_name'] = result['nombre']
            session['user_role'] = result['nombre_rol']
            session['user_email'] = result['email']
            
            return jsonify({
                'message': 'Login exitoso',
                'user': {
                    'id': result['id_usuario'],
                    'name': result['nombre'],
                    'role': result['nombre_rol'],
                    'email': result['email']
                }
            })
        else:
            return jsonify({'error': 'Credenciales incorrectas'}), 401
            
    except Exception as e:
        return jsonify({'error': f'Error en el login: {str(e)}'}), 500

@app.route('/api/auth/logout', methods=['POST'])
@login_required
def api_logout():
    """
    Cerrar sesión (API)
    ---
    tags:
      - Autenticación
    responses:
      200:
        description: Sesión cerrada
    """
    session.clear()
    return jsonify({'message': 'Sesión cerrada correctamente'})

@app.route('/api/auth/me')
@login_required
def get_current_user():
    """
    Obtener información del usuario actual
    ---
    tags:
      - Autenticación
    responses:
      200:
        description: Información del usuario
    """
    return jsonify({
        'id': session['user_id'],
        'name': session['user_name'],
        'role': session['user_role'],
        'email': session['user_email']
    })

# ==================== DASHBOARD API ====================
@app.route('/api/dashboard/estadisticas')
@login_required
def obtener_estadisticas_dashboard():
    """
    Obtener estadísticas para el dashboard
    ---
    tags:
      - Dashboard
    responses:
      200:
        description: Estadísticas del sistema
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT 
                (SELECT COUNT(*) FROM pedidos WHERE id_estado_pedido IN (1,2)) as pedidos_pendientes,
                (SELECT COUNT(*) FROM entregas WHERE id_estado_entrega IN (1,2)) as entregas_pendientes,
                (SELECT COUNT(*) FROM rutas WHERE id_estado_ruta = 1) as rutas_activas,
                (SELECT COUNT(*) FROM incidencias WHERE id_estado_incidencia = 1) as incidencias_activas
        """)
        stats = cur.fetchone()
        cur.close()
        return jsonify(stats)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== CLIENTES CRUD ====================
@app.route('/api/clientes', methods=['GET'])
@login_required
@role_required(['Admin', 'Planificador'])
def obtener_clientes():
    """
    Obtener todos los clientes
    ---
    tags:
      - Clientes
    responses:
      200:
        description: Lista de clientes
    """
    try:
        cur = mysql.connection.cursor()
        cur.callproc('clienteObtenerTodos')
        clientes = cur.fetchall()
        cur.close()
        return jsonify(clientes)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/clientes', methods=['POST'])
@login_required
@role_required(['Admin', 'Planificador'])
def crear_cliente():
    """
    Crear nuevo cliente
    ---
    tags:
      - Clientes
    parameters:
      - name: body
        in: body
        required: true
        schema:
          type: object
          required:
            - nombre
          properties:
            nombre:
              type: string
              example: "Juan Pérez"
            telefono:
              type: string
              example: "+1234567890"
            email:
              type: string
              example: "juan@empresa.com"
    responses:
      200:
        description: Cliente creado exitosamente
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        cur.callproc('clienteCrear', [
            data['nombre'],
            data.get('telefono'),
            data.get('email'),
            session['user_id']
        ])
        mysql.connection.commit()
        result = cur.fetchone()
        cur.close()
        return jsonify({'message': 'Cliente creado', 'id': result['id_cliente']})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/clientes/<int:id>', methods=['GET'])
@login_required
@role_required(['Admin', 'Planificador'])
def obtener_cliente(id):
    """
    Obtener cliente por ID
    ---
    tags:
      - Clientes
    parameters:
      - name: id
        in: path
        type: integer
        required: true
    responses:
      200:
        description: Datos del cliente
    """
    try:
        cur = mysql.connection.cursor()
        cur.callproc('clienteObtenerPorId', [id])
        cliente = cur.fetchone()
        cur.close()
        return jsonify(cliente)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/clientes/<int:id>', methods=['PUT'])
@login_required
@role_required(['Admin', 'Planificador'])
def actualizar_cliente(id):
    """
    Actualizar cliente
    ---
    tags:
      - Clientes
    parameters:
      - name: id
        in: path
        type: integer
        required: true
      - name: body
        in: body
        required: true
        schema:
          type: object
          properties:
            nombre:
              type: string
            telefono:
              type: string
            email:
              type: string
    responses:
      200:
        description: Cliente actualizado
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        cur.callproc('clienteActualizar', [
            id,
            data['nombre'],
            data.get('telefono'),
            data.get('email'),
            session['user_id']
        ])
        mysql.connection.commit()
        cur.close()
        return jsonify({'message': 'Cliente actualizado'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/clientes/<int:id>', methods=['DELETE'])
@login_required
@role_required(['Admin'])
def eliminar_cliente(id):
    """
    Eliminar cliente
    ---
    tags:
      - Clientes
    parameters:
      - name: id
        in: path
        type: integer
        required: true
    responses:
      200:
        description: Cliente eliminado
    """
    try:
        cur = mysql.connection.cursor()
        cur.callproc('clienteEliminar', [id, session['user_id']])
        mysql.connection.commit()
        cur.close()
        return jsonify({'message': 'Cliente eliminado'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== PEDIDOS CRUD ====================
@app.route('/api/pedidos', methods=['GET'])
@login_required
def obtener_pedidos():
    """
    Obtener todos los pedidos
    ---
    tags:
      - Pedidos
    responses:
      200:
        description: Lista de pedidos
    """
    try:
        cur = mysql.connection.cursor()
        if session['user_role'] == 'Repartidor':
            cur.callproc('pedidoObtenerPorRepartidor', [session['user_id']])
        else:
            cur.callproc('pedidoObtenerTodos')
        pedidos = cur.fetchall()
        cur.close()
        return jsonify(pedidos)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/pedidos', methods=['POST'])
@login_required
@role_required(['Admin', 'Planificador'])
def crear_pedido():
    """
    Crear nuevo pedido
    ---
    tags:
      - Pedidos
    parameters:
      - name: body
        in: body
        required: true
        schema:
          type: object
          required:
            - cliente_id
            - items_json
          properties:
            cliente_id:
              type: integer
              example: 1
            items_json:
              type: string
              example: '[{"producto_id": 1, "cantidad": 2}]'
    responses:
      200:
        description: Pedido creado exitosamente
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        cur.callproc('pedidoCrear', [
            data['cliente_id'],
            data['items_json'],
            session['user_id']
        ])
        mysql.connection.commit()
        result = cur.fetchone()
        cur.close()
        return jsonify({'message': 'Pedido creado', 'id': result['id_pedido']})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/pedidos/<int:id>', methods=['GET'])
@login_required
def obtener_pedido(id):
    """
    Obtener pedido por ID
    ---
    tags:
      - Pedidos
    parameters:
      - name: id
        in: path
        type: integer
        required: true
    responses:
      200:
        description: Datos del pedido
    """
    try:
        cur = mysql.connection.cursor()
        cur.callproc('pedidoObtenerPorId', [id])
        pedido = cur.fetchone()
        cur.close()
        return jsonify(pedido)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/pedidos/<int:id>/cancelar', methods=['POST'])
@login_required
@role_required(['Admin', 'Planificador'])
def cancelar_pedido(id):
    """
    Cancelar pedido
    ---
    tags:
      - Pedidos
    parameters:
      - name: id
        in: path
        type: integer
        required: true
      - name: body
        in: body
        required: true
        schema:
          type: object
          required:
            - motivo
          properties:
            motivo:
              type: string
              example: "Cliente solicitó cancelación"
    responses:
      200:
        description: Pedido cancelado
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        cur.callproc('pedidoCancelar', [
            id,
            data['motivo'],
            session['user_id']
        ])
        mysql.connection.commit()
        cur.close()
        return jsonify({'message': 'Pedido cancelado'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== ENTREGAS CRUD COMPLETO ====================
@app.route('/api/entregas', methods=['GET'])
@login_required
def obtener_entregas():
    """
    Obtener todas las entregas
    ---
    tags:
      - Entregas
    responses:
      200:
        description: Lista de entregas
    """
    try:
        cur = mysql.connection.cursor()
        if session['user_role'] == 'Repartidor':
            cur.callproc('entregaObtenerPorRepartidor', [session['user_id']])
        else:
            cur.callproc('entregaObtenerTodas')
        entregas = cur.fetchall()
        cur.close()
        return jsonify(entregas)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/entregas/<int:id>', methods=['GET'])
@login_required
def obtener_entrega(id):
    """
    Obtener entrega por ID
    ---
    tags:
      - Entregas
    parameters:
      - name: id
        in: path
        type: integer
        required: true
    responses:
      200:
        description: Datos de la entrega
    """
    try:
        cur = mysql.connection.cursor()
        cur.callproc('entregaObtenerPorId', [id])
        entrega = cur.fetchone()
        cur.close()
        return jsonify(entrega)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/entregas', methods=['POST'])
@login_required
@role_required(['Admin', 'Planificador'])
def asignar_entrega():
    """
    Asignar entrega
    ---
    tags:
      - Entregas
    parameters:
      - name: body
        in: body
        required: true
        schema:
          type: object
          required:
            - pedido_id
            - ruta_id
            - vehiculo_id
          properties:
            pedido_id:
              type: integer
              example: 1
            ruta_id:
              type: integer
              example: 1
            vehiculo_id:
              type: integer
              example: 1
    responses:
      200:
        description: Entrega asignada exitosamente
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        cur.callproc('entregaAsignar', [
            data['pedido_id'],
            data['ruta_id'],
            data['vehiculo_id'],
            session['user_id']
        ])
        mysql.connection.commit()
        result = cur.fetchone()
        cur.close()
        return jsonify({'message': 'Entrega asignada', 'id': result['id_entrega']})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/entregas/<int:id>', methods=['PUT'])
@login_required
@role_required(['Admin', 'Planificador'])
def actualizar_entrega(id):
    """
    Actualizar entrega
    ---
    tags:
      - Entregas
    parameters:
      - name: id
        in: path
        type: integer
        required: true
      - name: body
        in: body
        schema:
          type: object
          properties:
            ruta_id:
              type: integer
            vehiculo_id:
              type: integer
            id_estado_entrega:
              type: integer
    responses:
      200:
        description: Entrega actualizada
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        cur.callproc('entregaActualizar', [
            id,
            data.get('ruta_id'),
            data.get('vehiculo_id'),
            data.get('id_estado_entrega'),
            session['user_id']
        ])
        mysql.connection.commit()
        cur.close()
        return jsonify({'message': 'Entrega actualizada'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/entregas/<int:id>/confirmar', methods=['POST'])
@login_required
@role_required(['Admin', 'Planificador', 'Repartidor'])
def confirmar_entrega(id):
    """
    Confirmar entrega
    ---
    tags:
      - Entregas
    parameters:
      - name: id
        in: path
        type: integer
        required: true
      - name: body
        in: body
        required: true
        schema:
          type: object
          required:
            - hora_real
          properties:
            hora_real:
              type: string
              example: "2024-01-01 14:30:00"
            evidencia:
              type: string
              example: "foto_base64"
    responses:
      200:
        description: Entrega confirmada
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        cur.callproc('entregaConfirmar', [
            id,
            data['hora_real'],
            data.get('evidencia', ''),
            session['user_id']
        ])
        mysql.connection.commit()
        cur.close()
        return jsonify({'message': 'Entrega confirmada'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/entregas/<int:id>/reintento', methods=['POST'])
@login_required
@role_required(['Admin', 'Planificador', 'Repartidor'])
def reintentar_entrega(id):
    """
    Registrar reintento de entrega
    ---
    tags:
      - Entregas
    parameters:
      - name: id
        in: path
        type: integer
        required: true
      - name: body
        in: body
        required: true
        schema:
          type: object
          required:
            - motivo
          properties:
            motivo:
              type: string
              example: "Cliente no estaba en domicilio"
    responses:
      200:
        description: Reintento registrado
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        cur.callproc('entregaReintento', [
            id,
            data['motivo'],
            session['user_id']
        ])
        mysql.connection.commit()
        cur.close()
        return jsonify({'message': 'Reintento registrado'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== RUTAS CRUD COMPLETO ====================
@app.route('/api/rutas', methods=['GET'])
@login_required
@role_required(['Admin', 'Planificador'])
def obtener_rutas():
    """
    Obtener todas las rutas
    ---
    tags:
      - Rutas
    responses:
      200:
        description: Lista de rutas
    """
    try:
        cur = mysql.connection.cursor()
        cur.callproc('rutaObtenerTodas')
        rutas = cur.fetchall()
        cur.close()
        return jsonify(rutas)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/rutas/<int:id>', methods=['GET'])
@login_required
@role_required(['Admin', 'Planificador'])
def obtener_ruta(id):
    """
    Obtener ruta por ID
    ---
    tags:
      - Rutas
    parameters:
      - name: id
        in: path
        type: integer
        required: true
    responses:
      200:
        description: Datos de la ruta
    """
    try:
        cur = mysql.connection.cursor()
        cur.callproc('rutaObtenerPorId', [id])
        ruta = cur.fetchone()
        cur.close()
        return jsonify(ruta)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/rutas', methods=['POST'])
@login_required
@role_required(['Admin', 'Planificador'])
def crear_ruta():
    """
    Crear nueva ruta
    ---
    tags:
      - Rutas
    parameters:
      - name: body
        in: body
        required: true
        schema:
          type: object
          required:
            - zona_id
            - fecha
            - secuencia_json
          properties:
            zona_id:
              type: integer
              example: 1
            fecha:
              type: string
              example: "2024-01-01"
            secuencia_json:
              type: string
              example: '[{"pedido_id": 1, "orden": 1}]'
    responses:
      200:
        description: Ruta creada exitosamente
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        cur.callproc('rutaCrear', [
            data['zona_id'],
            data['fecha'],
            data['secuencia_json'],
            session['user_id']
        ])
        mysql.connection.commit()
        result = cur.fetchone()
        cur.close()
        return jsonify({'message': 'Ruta creada', 'id': result['id_ruta']})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/rutas/<int:id>', methods=['PUT'])
@login_required
@role_required(['Admin', 'Planificador'])
def actualizar_ruta(id):
    """
    Actualizar ruta
    ---
    tags:
      - Rutas
    parameters:
      - name: id
        in: path
        type: integer
        required: true
      - name: body
        in: body
        schema:
          type: object
          properties:
            zona_id:
              type: integer
            fecha:
              type: string
            secuencia_json:
              type: string
            id_estado_ruta:
              type: integer
    responses:
      200:
        description: Ruta actualizada
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        cur.callproc('rutaActualizar', [
            id,
            data.get('zona_id'),
            data.get('fecha'),
            data.get('secuencia_json'),
            data.get('id_estado_ruta'),
            session['user_id']
        ])
        mysql.connection.commit()
        cur.close()
        return jsonify({'message': 'Ruta actualizada'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/rutas/<int:id>', methods=['DELETE'])
@login_required
@role_required(['Admin'])
def eliminar_ruta(id):
    """
    Eliminar ruta
    ---
    tags:
      - Rutas
    parameters:
      - name: id
        in: path
        type: integer
        required: true
    responses:
      200:
        description: Ruta eliminada
    """
    try:
        cur = mysql.connection.cursor()
        cur.callproc('rutaEliminar', [id, session['user_id']])
        mysql.connection.commit()
        cur.close()
        return jsonify({'message': 'Ruta eliminada'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/rutas/<int:id>/paradas', methods=['GET'])
@login_required
@role_required(['Admin', 'Planificador'])
def obtener_paradas_ruta(id):
    """
    Obtener paradas de una ruta
    ---
    tags:
      - Rutas
    parameters:
      - name: id
        in: path
        type: integer
        required: true
    responses:
      200:
        description: Lista de paradas
    """
    try:
        cur = mysql.connection.cursor()
        cur.callproc('rutaObtenerParadas', [id])
        paradas = cur.fetchall()
        cur.close()
        return jsonify(paradas)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== INCIDENCIAS CRUD ====================
@app.route('/api/incidencias', methods=['GET'])
@login_required
def obtener_incidencias():
    """
    Obtener todas las incidencias
    ---
    tags:
      - Incidencias
    responses:
      200:
        description: Lista de incidencias
    """
    try:
        cur = mysql.connection.cursor()
        cur.callproc('incidenciaObtenerTodas')
        incidencias = cur.fetchall()
        cur.close()
        return jsonify(incidencias)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/incidencias', methods=['POST'])
@login_required
@role_required(['Admin', 'Planificador', 'Repartidor'])
def crear_incidencia():
    """
    Crear nueva incidencia
    ---
    tags:
      - Incidencias
    parameters:
      - name: body
        in: body
        required: true
        schema:
          type: object
          required:
            - id_tipo_incidencia
            - id_zona
            - descripcion
            - fecha_inicio
          properties:
            id_tipo_incidencia:
              type: integer
              example: 1
            id_zona:
              type: integer
              example: 1
            descripcion:
              type: string
              example: "Bloqueo vial por manifestación"
            fecha_inicio:
              type: string
              example: "2024-01-01 10:00:00"
            fecha_fin:
              type: string
              example: "2024-01-01 12:00:00"
            id_nivel_impacto:
              type: integer
              example: 2
    responses:
      200:
        description: Incidencia registrada
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        cur.callproc('incidenciaRegistrar', [
            data['id_tipo_incidencia'],
            data['id_zona'],
            data['descripcion'],
            data['fecha_inicio'],
            data.get('fecha_fin'),
            data.get('id_nivel_impacto', 1),
            session['user_id']
        ])
        mysql.connection.commit()
        result = cur.fetchone()
        cur.close()
        return jsonify({'message': 'Incidencia registrada', 'id': result['id_incidencia']})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== REPORTES ====================
@app.route('/api/reportes/otp')
@login_required
@role_required(['Admin', 'Auditor', 'Planificador'])
def reporte_otp():
    """
    Reporte OTP por rango de fechas
    ---
    tags:
      - Reportes
    parameters:
      - name: desde
        in: query
        type: string
        example: "2024-01-01"
      - name: hasta
        in: query
        type: string
        example: "2024-01-31"
    responses:
      200:
        description: Datos del reporte OTP
    """
    try:
        desde = request.args.get('desde')
        hasta = request.args.get('hasta')
        cur = mysql.connection.cursor()
        cur.callproc('otpRango', [desde, hasta])
        data = cur.fetchall()
        cur.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/reportes/costos-km')
@login_required
@role_required(['Admin', 'Auditor', 'Planificador'])
def reporte_costos_km():
    """
    Reporte de costos por KM
    ---
    tags:
      - Reportes
    parameters:
      - name: desde
        in: query
        type: string
      - name: hasta
        in: query
        type: string
    responses:
      200:
        description: Datos de costos por KM
    """
    try:
        desde = request.args.get('desde')
        hasta = request.args.get('hasta')
        cur = mysql.connection.cursor()
        cur.callproc('costosKMRango', [desde, hasta])
        data = cur.fetchall()
        cur.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/reportes/productividad')
@login_required
@role_required(['Admin', 'Auditor', 'Planificador'])
def reporte_productividad():
    """
    Reporte de productividad por repartidor
    ---
    tags:
      - Reportes
    parameters:
      - name: desde
        in: query
        type: string
      - name: hasta
        in: query
        type: string
    responses:
      200:
        description: Datos de productividad
    """
    try:
        desde = request.args.get('desde')
        hasta = request.args.get('hasta')
        cur = mysql.connection.cursor()
        cur.callproc('productividadRepartidor', [desde, hasta])
        data = cur.fetchall()
        cur.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== VISTAS HTML ====================
@app.route('/dashboard')
@login_required
def dashboard_page():
    """Página de dashboard"""
    return render_template('dashboard.html')

@app.route('/pedidos')
@login_required
def pedidos_page():
    """Página de gestión de pedidos"""
    return render_template('pedidos.html')

@app.route('/entregas')
@login_required
def entregas_page():
    """Página de gestión de entregas"""
    return render_template('entregas.html')

@app.route('/rutas')
@login_required
@role_required(['Admin', 'Planificador'])
def rutas_page():
    """Página de gestión de rutas"""
    return render_template('rutas.html')

@app.route('/reportes')
@login_required
@role_required(['Admin', 'Auditor', 'Planificador'])
def reportes_page():
    """Página de reportes"""
    return render_template('reportes.html')

@app.route('/incidencias')
@login_required
def incidencias_page():
    """Página de gestión de incidencias"""
    return render_template('incidencias.html')

# ==================== INICIALIZACIÓN ====================
if __name__ == '__main__':
    print("=" * 50)
    print("🚚 LUM System - Logística Última Milla")
    print("📊 Dashboard: http://localhost:5000/")
    print("🔐 Login: http://localhost:5000/login") 
    print("📚 API Docs: http://localhost:5000/api/docs/")
    print("❤️  Health Check: http://localhost:5000/api/health")
    print("=" * 50)
    app.run(debug=True, host='0.0.0.0', port=5000)