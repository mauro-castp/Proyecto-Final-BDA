# app.py - CON RUTAS CORREGIDAS
import os
from flask import Flask, render_template, session, jsonify, request, redirect, url_for, flash
from flasgger import Swagger
from config import Config, swagger_template
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required
from datetime import datetime
from routes.clientes import init_clientes_routes
from routes.empresas import init_empresas_routes
from routes.pedidos import init_pedidos_routes
from routes.incidencias import init_incidencias_routes
from routes.entregas import init_entregas_routes

# Obtener el directorio base del proyecto
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

app = Flask(__name__, 
    template_folder=os.path.join(BASE_DIR, '..', 'templates'),
    static_folder=os.path.join(BASE_DIR, '..', 'static')
)

app.config.from_object(Config)

# Inicializar extensiones
mysql = MySQL(app)
swagger = Swagger(app, template=swagger_template)

# Después de crear la app y mysql
clientes_bp = init_clientes_routes(app, mysql)
app.register_blueprint(clientes_bp, url_prefix='/')

empresas_bp = init_empresas_routes(app, mysql)
app.register_blueprint(empresas_bp, url_prefix='/')

pedidos_bp = init_pedidos_routes(app, mysql)
app.register_blueprint(pedidos_bp, url_prefix='/')

incidencias_bp = init_incidencias_routes(app, mysql)
app.register_blueprint(incidencias_bp, url_prefix='/')

entregas_bp = init_entregas_routes(app, mysql)
app.register_blueprint(entregas_bp, url_prefix='/')

# Context processor
@app.context_processor
def inject_user_data():
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
    """Página de login"""
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
                session['user_role_name'] = result['nombre_rol']
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
    """Health Check del sistema"""
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

# ==================== DASHBOARD API ====================
@app.route('/api/dashboard/estadisticas')
@login_required
def obtener_estadisticas_dashboard():
    """Obtener estadísticas para el dashboard"""
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
                    (SELECT COUNT(*) FROM entregas WHERE id_estado_entrega = 5) * 100.0 / 
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
    """Obtener entregas planificadas para hoy - VISTA"""
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vEntregasHoy")
        entregas = cur.fetchall()
        cur.close()
        return jsonify(entregas)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/vistas/pedidos-por-estado')
@login_required
def obtener_pedidos_por_estado():
    """Obtener pedidos por estado - VISTA"""
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vPedidosPorEstado")
        pedidos_estado = cur.fetchall()
        cur.close()
        return jsonify(pedidos_estado)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/vistas/entregas-zona')
@login_required
def obtener_entregas_zona():
    """Obtener entregas por zona - VISTA"""
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
    """Obtener incidencias activas - VISTA"""
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
def obtener_tiempo_promedio_entrega():
    """Obtener tiempo promedio de entrega - VISTA"""
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
def obtener_productividad_repartidores():
    """Obtener productividad de repartidores - VISTA"""
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vProductividadRepartidor")
        productividad = cur.fetchall()
        cur.close()
        return jsonify(productividad)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/vistas/costos-km')
@login_required
def obtener_costos_km():
    """Obtener costos por KM por vehículo - VISTA"""
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM vCostosPorKM")
        costos = cur.fetchall()
        cur.close()
        return jsonify(costos)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== PÁGINAS HTML ====================
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
@role_required([1, 2])
def clientes_page():
    """Página de gestión de clientes"""
    return render_template('clientes.html')

@app.route('/empresas')
@login_required
@role_required([1, 2])
def empresas_page():
    """Página de gestión de empresas"""
    return render_template('empresas.html')

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