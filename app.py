# app.py - VERSIÓN FINAL COMPLETA
from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
from flask_mysqldb import MySQL
from functools import wraps
import os
from datetime import datetime
from flasgger import Swagger
import json

app = Flask(__name__)

# Configuración
app.secret_key = 'clave-secreta-lum-2024-desarrollo'
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'proyecto_user'
app.config['MYSQL_PASSWORD'] = '666'
app.config['MYSQL_DB'] = 'proyecto'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'
app.config['MYSQL_CHARSET'] = 'utf8mb4' 

# Configuración Swagger
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

@app.context_processor
def inject_user_data():
    """Inyecta datos del usuario en todos los templates"""
    return {
        'user_rol': session.get('user_role_name', ''),
        'user_name': session.get('user_name', ''),
        'user_id': session.get('user_id', '')
    }

# ==================== RUTAS PRINCIPALES ====================
@app.route('/')
def index():
    """Página principal del sistema"""
    if 'user_id' not in session:
        return redirect(url_for('login'))
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    """Página de login - CORREGIDO"""
    if 'user_id' in session:
        return redirect(url_for('index'))
    
    if request.method == 'POST':
        try:
            email = request.form['email']
            password = request.form['password']
            
            cur = mysql.connection.cursor()
            cur.callproc('inicioSesion', [email, password])
            result = cur.fetchone()
            cur.close()
            
            if result:
                session['user_id'] = result['id_usuario']
                session['user_name'] = result['nombre']
                session['user_role'] = result['id_rol']
                session['user_role_name'] = result['nombre_rol']  # Nuevo campo
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
    Autenticación de usuario (API) - CORREGIDO
    """
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')
        
        cur = mysql.connection.cursor()
        cur.callproc('inicioSesion', [email, password])
        result = cur.fetchone()
        cur.close()
        
        if result:
            session['user_id'] = result['id_usuario']
            session['user_name'] = result['nombre']
            session['user_role'] = result['id_rol']
            session['user_role_name'] = result['nombre_rol']  # Nuevo campo
            session['user_email'] = result['email']
            
            return jsonify({
                'message': 'Login exitoso',
                'user': {
                    'id': result['id_usuario'],
                    'name': result['nombre'],
                    'role_id': result['id_rol'],
                    'role_name': result['nombre_rol'],  # Nuevo campo
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
    """
    session.clear()
    return jsonify({'message': 'Sesión cerrada correctamente'})

@app.route('/api/auth/me')
@login_required
def get_current_user():
    """
    Obtener información del usuario actual
    """
    return jsonify({
        'id': session['user_id'],
        'name': session['user_name'],
        'role_id': session['user_role'],
        'role_name': session.get('user_role_name', 'Sin rol'),
        'email': session['user_email']
    })

# ==================== DASHBOARD API ====================
@app.route('/api/dashboard/estadisticas')
@login_required
def obtener_estadisticas_dashboard():
    """
    Obtener estadísticas para el dashboard
    """
    try:
        cur = mysql.connection.cursor()
        
        # Estadísticas básicas
        cur.execute("""
            SELECT 
                (SELECT COUNT(*) FROM pedidos WHERE id_estado_pedido IN (1,2)) as pedidos_pendientes,
                (SELECT COUNT(*) FROM entregas WHERE id_estado_entrega IN (1,2)) as entregas_pendientes,
                (SELECT COUNT(*) FROM rutas WHERE id_estado_ruta = 1) as rutas_activas,
                (SELECT COUNT(*) FROM incidencias WHERE id_estado_incidencia = 1) as incidencias_activas,
                (SELECT ROUND(
                    (SELECT COUNT(*) FROM entregas WHERE id_estado_entrega = 3) * 100.0 / 
                    NULLIF((SELECT COUNT(*) FROM entregas), 0), 2
                )) as tasa_exito
        """)
        stats = cur.fetchone()
        
        # Datos de vistas para dashboard
        cur.execute("SELECT * FROM vPedidosPorEstado")
        pedidos_por_estado = cur.fetchall()
        
        cur.execute("SELECT * FROM vEntregasHoy")
        entregas_hoy = cur.fetchall()
        
        cur.execute("SELECT * FROM vIncidenciasActivas")
        incidencias_activas = cur.fetchall()
        
        cur.execute("SELECT * FROM vEntregasPorZona")
        entregas_zona = cur.fetchall()
        
        cur.execute("SELECT * FROM vTiempoPromedioEntrega")
        tiempo_promedio_entrega = cur.fetchone()
        
        cur.close()
        
        return jsonify({
            'estadisticas': stats,
            'pedidos_por_estado': pedidos_por_estado,
            'entregas_hoy': entregas_hoy,
            'incidencias_activas': incidencias_activas,
            'entregas_zona': entregas_zona,
            'tiempo_promedio_entrega': tiempo_promedio_entrega
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== VISTAS - ENDPOINTS ====================
@app.route('/api/vistas/entregas-hoy')
@login_required
def obtener_entregas_hoy():
    """
    Obtener entregas planificadas para hoy - VISTA
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vEntregasHoy")
        entregas = cur.fetchall()
        cur.close()
        return jsonify(entregas)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/vistas/otp-ruta-mes')
@login_required
@role_required([1, 4, 2])  # Admin, Auditor, Planificador
def obtener_otp_ruta_mes():
    """
    Obtener OTP por ruta del mes actual - VISTA
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vOtpPorRutaMes")
        otp_data = cur.fetchall()
        cur.close()
        return jsonify(otp_data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/vistas/costos-km')
@login_required
@role_required([1, 4, 2])
def obtener_costos_km():
    """
    Obtener costos por KM por vehículo - VISTA
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vCostosPorKM")
        costos = cur.fetchall()
        cur.close()
        return jsonify(costos)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/vistas/entregas-zona')
@login_required
def obtener_entregas_zona():
    """
    Obtener entregas por zona - VISTA
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vEntregasPorZona")
        entregas_zona = cur.fetchall()
        cur.close()
        return jsonify(entregas_zona)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/vistas/incidencias-activas')
@login_required
def obtener_incidencias_activas():
    """
    Obtener incidencias activas - VISTA
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vIncidenciasActivas")
        incidencias = cur.fetchall()
        cur.close()
        return jsonify(incidencias)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/vistas/tiempo-promedio-entrega')
@login_required
@role_required([1, 4, 2])
def obtener_tiempo_promedio_entrega():
    """
    Obtener tiempo promedio de entrega - VISTA
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vTiempoPromedioEntrega")
        tiempo_promedio = cur.fetchone()
        cur.close()
        return jsonify(tiempo_promedio)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/vistas/productividad-repartidores')
@login_required
@role_required([1, 4, 2])
def obtener_productividad_repartidores():
    """
    Obtener productividad de repartidores - VISTA
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vProductividadRepartidor")
        productividad = cur.fetchall()
        cur.close()
        return jsonify(productividad)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/vistas/pedidos-por-estado')
@login_required
def obtener_pedidos_por_estado():
    """
    Obtener pedidos por estado - VISTA
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vPedidosPorEstado")
        pedidos_estado = cur.fetchall()
        cur.close()
        return jsonify(pedidos_estado)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== CLIENTES CRUD ====================
@app.route('/api/clientes', methods=['GET'])
@login_required
@role_required([1, 2])
def obtener_clientes():
    """
    Obtener todos los clientes - CORREGIDO
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT c.id_cliente, c.nombre, c.telefono, c.email, 
                   dc.direccion, z.nombre_zona, c.id_estado
            FROM clientes c
            LEFT JOIN direcciones_cliente dc ON c.id_cliente = dc.id_cliente
            LEFT JOIN zonas z ON dc.id_zona = z.id_zona
            WHERE c.id_estado = 1
        """)
        clientes = cur.fetchall()
        cur.close()
        return jsonify(clientes)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/clientes', methods=['POST'])
@login_required
@role_required([1, 2])
def crear_cliente():
    """
    Crear nuevo cliente - CORREGIDO
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        
        cur.callproc('clienteCrearActualizar', [
            None,
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

@app.route('/api/clientes/<int:id>', methods=['GET'])
@login_required
@role_required([1, 2])
def obtener_cliente(id):
    """
    Obtener cliente por ID
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT c.id_cliente, c.nombre, c.telefono, c.email, 
                   dc.direccion, dc.id_zona, c.id_estado
            FROM clientes c
            LEFT JOIN direcciones_cliente dc ON c.id_cliente = dc.id_cliente
            WHERE c.id_cliente = %s
        """, (id,))
        cliente = cur.fetchone()
        cur.close()
        return jsonify(cliente)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/clientes/<int:id>', methods=['PUT'])
@login_required
@role_required([1, 2])
def actualizar_cliente(id):
    """
    Actualizar cliente - CORREGIDO
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        
        cur.callproc('clienteCrearActualizar', [
            id,
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

@app.route('/api/clientes/<int:id>', methods=['DELETE'])
@login_required
@role_required([1])
def eliminar_cliente(id):
    """
    Eliminar cliente (soft delete)
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("UPDATE clientes SET id_estado = 0 WHERE id_cliente = %s", (id,))
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
    Obtener todos los pedidos - CORREGIDO
    """
    try:
        cur = mysql.connection.cursor()
        if session['user_role'] == 3:  # Repartidor
            cur.execute("""
                SELECT p.*, c.nombre as nombre_cliente, ep.nombre_estado
                FROM pedidos p
                JOIN clientes c ON p.id_cliente = c.id_cliente
                JOIN estados_pedido ep ON p.id_estado_pedido = ep.id_estado_pedido
                JOIN entregas e ON p.id_pedido = e.id_pedido
                WHERE e.id_repartidor = %s
            """, (session['user_id'],))
        else:
            cur.execute("""
                SELECT p.*, c.nombre as nombre_cliente, ep.nombre_estado
                FROM pedidos p
                JOIN clientes c ON p.id_cliente = c.id_cliente
                JOIN estados_pedido ep ON p.id_estado_pedido = ep.id_estado_pedido
            """)
        pedidos = cur.fetchall()
        cur.close()
        return jsonify(pedidos)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/pedidos', methods=['POST'])
@login_required
@role_required([1, 2])
def crear_pedido():
    """
    Crear nuevo pedido - CORREGIDO
    """
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

@app.route('/api/pedidos/<int:id>', methods=['GET'])
@login_required
def obtener_pedido(id):
    """
    Obtener pedido por ID
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT p.*, c.nombre as nombre_cliente, ep.nombre_estado,
                   dc.direccion, z.nombre_zona
            FROM pedidos p
            JOIN clientes c ON p.id_cliente = c.id_cliente
            JOIN estados_pedido ep ON p.id_estado_pedido = ep.id_estado_pedido
            JOIN direcciones_cliente dc ON p.id_direccion_entrega = dc.id_direccion
            JOIN zonas z ON dc.id_zona = z.id_zona
            WHERE p.id_pedido = %s
        """, (id,))
        pedido = cur.fetchone()
        
        cur.execute("""
            SELECT dp.*, pr.nombre_producto, pr.precio_unitario
            FROM detalle_pedido dp
            JOIN productos pr ON dp.id_producto = pr.id_producto
            WHERE dp.id_pedido = %s
        """, (id,))
        detalle = cur.fetchall()
        pedido['detalle'] = detalle
        
        cur.close()
        return jsonify(pedido)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/pedidos/<int:id>/cancelar', methods=['POST'])
@login_required
@role_required([1, 2])
def cancelar_pedido(id):
    """
    Cancelar pedido - CORREGIDO
    """
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

# ==================== ENTREGAS CRUD ====================
@app.route('/api/entregas', methods=['GET'])
@login_required
def obtener_entregas():
    """
    Obtener todas las entregas - CORREGIDO
    """
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

@app.route('/api/entregas/<int:id>', methods=['GET'])
@login_required
def obtener_entrega(id):
    """
    Obtener entrega por ID
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT e.*, p.id_pedido, c.nombre as nombre_cliente, 
                   ee.nombre_estado, r.nombre_ruta, u.nombre as nombre_repartidor,
                   dc.direccion
            FROM entregas e
            JOIN pedidos p ON e.id_pedido = p.id_pedido
            JOIN clientes c ON p.id_cliente = c.id_cliente
            JOIN estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
            LEFT JOIN rutas r ON e.id_ruta = r.id_ruta
            LEFT JOIN usuarios u ON e.id_repartidor = u.id_usuario
            JOIN direcciones_cliente dc ON p.id_direccion_entrega = dc.id_direccion
            WHERE e.id_entrega = %s
        """, (id,))
        entrega = cur.fetchone()
        cur.close()
        return jsonify(entrega)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/entregas', methods=['POST'])
@login_required
@role_required([1, 2])
def asignar_entrega():
    """
    Asignar entrega - CORREGIDO
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        
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
            return jsonify({'message': 'Entrega asignada', 'id': result['status']})
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/entregas/<int:id>/confirmar', methods=['POST'])
@login_required
@role_required([1, 2, 3])
def confirmar_entrega(id):
    """
    Confirmar entrega - CORREGIDO
    """
    try:
        data = request.get_json()
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
            return jsonify({'message': 'Entrega confirmada'})
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/entregas/<int:id>/reintento', methods=['POST'])
@login_required
@role_required([1, 2, 3])
def reintentar_entrega(id):
    """
    Registrar reintento de entrega - CORREGIDO
    """
    try:
        data = request.get_json()
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
            return jsonify({'message': 'Reintento registrado'})
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== RUTAS CRUD ====================
@app.route('/api/rutas', methods=['GET'])
@login_required
@role_required([1, 2])
def obtener_rutas():
    """
    Obtener todas las rutas
    """
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

@app.route('/api/rutas/<int:id>', methods=['GET'])
@login_required
@role_required([1, 2])
def obtener_ruta(id):
    """
    Obtener ruta por ID
    """
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

@app.route('/api/rutas', methods=['POST'])
@login_required
@role_required([1, 2])
def crear_ruta():
    """
    Crear nueva ruta - CORREGIDO
    """
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

# ==================== INCIDENCIAS CRUD ====================
@app.route('/api/incidencias', methods=['GET'])
@login_required
def obtener_incidencias():
    """
    Obtener todas las incidencias
    """
    try:
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT i.*, z.nombre_zona, ti.nombre_tipo, ei.nombre_estado,
                   ni.nombre_nivel, u.nombre as nombre_reporta
            FROM incidencias i
            JOIN zonas z ON i.id_zona = z.id_zona
            JOIN tipos_incidencia ti ON i.id_tipo_incidencia = ti.id_tipo_incidencia
            JOIN estados_incidencia ei ON i.id_estado_incidencia = ei.id_estado_incidencia
            JOIN niveles_impacto ni ON i.id_nivel_impacto = ni.id_nivel_impacto
            LEFT JOIN usuarios u ON i.id_usuario_reporta = u.id_usuario
        """)
        incidencias = cur.fetchall()
        cur.close()
        return jsonify(incidencias)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/incidencias', methods=['POST'])
@login_required
@role_required([1, 2, 3])
def crear_incidencia():
    """
    Crear nueva incidencia - CORREGIDO
    """
    try:
        data = request.get_json()
        cur = mysql.connection.cursor()
        
        cur.callproc('incidenciaRegistrar', [
            data['id_zona'],
            data['id_tipo_incidencia'],
            data['desde'],
            data.get('hasta')
        ])
        result = cur.fetchone()
        mysql.connection.commit()
        cur.close()
        
        return jsonify({'message': 'Incidencia registrada', 'id': result['id_incidencia']})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== REPORTES ====================
@app.route('/api/reportes/otp')
@login_required
@role_required([1, 4, 2])
def reporte_otp():
    """
    Reporte OTP por rango de fechas - CORREGIDO
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
@role_required([1, 4, 2])
def reporte_costos_km():
    """
    Reporte de costos por KM - CORREGIDO
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
@role_required([1, 4, 2])
def reporte_productividad():
    """
    Reporte de productividad por repartidor - CORREGIDO
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

@app.route('/api/reportes/entregas-zona')
@login_required
@role_required([1, 4, 2])
def reporte_entregas_zona():
    """
    Reporte de entregas por zona - NUEVO
    """
    try:
        desde = request.args.get('desde')
        hasta = request.args.get('hasta')
        cur = mysql.connection.cursor()
        cur.callproc('entregasZona', [desde, hasta])
        data = cur.fetchall()
        cur.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/reportes/kpi-mes')
@login_required
@role_required([1, 4, 2])
def reporte_kpi_mes():
    """
    Reporte KPI global por mes - NUEVO
    """
    try:
        anio = request.args.get('anio', datetime.now().year)
        mes = request.args.get('mes', datetime.now().month)
        cur = mysql.connection.cursor()
        cur.callproc('kpiGlobalMes', [anio, mes])
        data = cur.fetchall()
        cur.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/reportes/auditoria-entregas')
@login_required
@role_required([1, 4])
def reporte_auditoria_entregas():
    """
    Reporte de auditoría de entregas - NUEVO
    """
    try:
        desde = request.args.get('desde')
        hasta = request.args.get('hasta')
        cur = mysql.connection.cursor()
        cur.callproc('auditoriaEntrega', [desde, hasta])
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
@role_required([1, 2])
def rutas_page():
    """Página de gestión de rutas"""
    return render_template('rutas.html')

@app.route('/reportes')
@login_required
@role_required([1, 4, 2])
def reportes_page():
    """Página de reportes"""
    return render_template('reportes.html')

@app.route('/clientes')
@login_required
@role_required([1, 2])  # Solo admin y planificador
def clientes_page():
    """Página de gestión de clientes"""
    return render_template('clientes.html')

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