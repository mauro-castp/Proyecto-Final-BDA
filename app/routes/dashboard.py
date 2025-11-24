# routes/dashboard.py
from flask import Blueprint, jsonify, session
from flask_mysqldb import MySQL
from utils.decorators import login_required

dashboard_bp = Blueprint('dashboard', __name__)

def init_dashboard_routes(app, mysql):
    @dashboard_bp.route('/api/dashboard/estadisticas')
    @login_required
    def obtener_estadisticas_dashboard():
        """Obtener estadísticas para el dashboard - PROCEDIMIENTOS Y VISTAS"""
        try:
            cur = mysql.connection.cursor()
            
            # Estadísticas básicas - PROCEDIMIENTO
            cur.callproc('dashboardEstadisticas')
            stats = cur.fetchone()
            
            # Datos de vistas para dashboard
            # Vista: vPedidosPorEstado
            cur.execute("SELECT * FROM vPedidosPorEstado")
            pedidos_por_estado = cur.fetchall()
            
            # Vista: vEntregasHoy
            cur.execute("SELECT * FROM vEntregasHoy")
            entregas_hoy = cur.fetchall()
            
            # Vista: vIncidenciasActivas
            cur.execute("SELECT * FROM vIncidenciasActivas")
            incidencias_activas = cur.fetchall()
            
            # Vista: vEntregasPorZona
            cur.execute("SELECT * FROM vEntregasPorZona")
            entregas_zona = cur.fetchall()
            
            # Vista: vTiempoPromedioEntrega
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

    return dashboard_bp